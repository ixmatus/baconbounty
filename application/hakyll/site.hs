{-# LANGUAGE Arrows            #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

--------------------------------------------------------------------------------
import           Control.Applicative ((<$>))
import           Data.Monoid         (mappend, mconcat)
import           Prelude             hiding (id)
import           System.Cmd          ()
import           System.FilePath     ()

import           Data.List                   (intercalate)
import           Text.Blaze.Html             (toHtml, toValue, (!))
import qualified Text.Blaze.Html5            as H
import qualified Text.Blaze.Html5.Attributes as A
import           Text.Blaze.Html.Renderer.String (renderHtml)

import Hakyll

main :: IO ()
main = hakyllWith siteConfiguration $ do
    
    match ("robots.txt") $ do
        route idRoute
        compile copyFileCompiler
    
    match ("static/files/*" .||. "static/images/*" .||. "static/icons/*" .||. "static/fonts/*" .||. "static/scripts/**") $ do
        route idRoute
        compile copyFileCompiler
    
    -- Static CSS compressor (Bootstrap files mostly)
    match ("static/css/*.css") $ do
        route idRoute
        compile compressCssCompiler
    
    match ("static/css/default.hs") $ do
        route   $ setExtension "css"
        -- Make sure to CD into the dir so any other CSS modules will be imported properly by runghc
        compile $ getResourceString >>= withItemBody (unixFilter "runghc" ["-istatic/css"])
    
    -- Build tags
    tags <- buildTags "articles/*.md" (fromCapture "tags/*.tpl")
    
    -- Render each and every post
    match "articles/*.md" $ do
        route   $ setExtension ".tpl"
        compile $ do
            pandocCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/article.html" (postCtx tags)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls
    
    -- Post list
    create ["articles.tpl"] $ do
        route idRoute
        compile $ do
            list <- postList tags "articles/*.md" recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/articles.html"
                        (constField "title" "Articles" `mappend`
                            constField "articles" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls
    
    -- Post tags
    tagsRules tags $ \tag pattern -> do
        let title = "Articles tagged <span class=\"tagheading\">" ++ tag ++ "</span>"

        -- Copied from posts, need to refactor
        route idRoute
        compile $ do
            list <- postList tags pattern recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/articles.html"
                        (constField "title" title `mappend`
                            constField "articles" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

        -- Create RSS feed as well
        version "rss" $ do
            route   $ setExtension "xml"
            compile $ loadAllSnapshots pattern "content"
                >>= fmap (take 10) . recentFirst
                >>= renderAtom (feedConfiguration title) feedCtx
    
    -- Index
    match "index.md" $ do
        route   $ setExtension ".tpl"
        compile $ do
            list <- postSummary tags "articles/*.md" $ fmap (take 3) . recentFirst
            let indexContext = constField "articles" list `mappend`
                    field "tags" (\_ -> renderTagUl tags) `mappend`
                    defaultContext

            pandocCompiler
                >>= applyAsTemplate indexContext
                >>= loadAndApplyTemplate "templates/default.html" indexContext
                >>= relativizeUrls
    
    -- Read templates
    match "templates/*" $ compile $ templateCompiler
    
    -- Render some static pages
    match (fromList pages) $ do
        route   $ setExtension ".tpl"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
    
    -- Render RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            loadAllSnapshots "articles/*.md" "content"
                >>= fmap (take 10) . recentFirst
                >>= renderAtom (feedConfiguration "All posts") feedCtx
    
    where
        pages =
            [ "about.md"
            ]

siteConfiguration :: Configuration
siteConfiguration = defaultConfiguration
    {
      deployCommand = "rsync -av --progress _site/ ../snaplets/heist/templates/ --exclude static && cp -Rf _site/static ../"
    }

--------------------------------------------------------------------------------
postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%B %e, %Y"
    , tagsField "tags" tags
    , defaultContext
    ]

--------------------------------------------------------------------------------
feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

--------------------------------------------------------------------------------
feedConfiguration :: String -> FeedConfiguration
feedConfiguration title = FeedConfiguration
    { feedTitle       = "pspringmeyer - " ++ title
    , feedDescription = "Personal Site of Parnell Springmeyer"
    , feedAuthorName  = "Parnell Springmeyer"
    , feedAuthorEmail = "ixmatus@gmail.com"
    , feedRoot        = "http://ixmat.us"
    }

--------------------------------------------------------------------------------
postList :: Tags -> Pattern -> ([Item String] -> Compiler [Item String])
         -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/article-item.html"
    posts       <- preprocess' =<< loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts

--------------------------------------------------------------------------------
postSummary :: Tags -> Pattern -> ([Item String] -> Compiler [Item String])
         -> Compiler String
postSummary tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/article-summary.html"
    posts       <- preprocess' =<< loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts

--------------------------------------------------------------------------------
-- | Render a simple tag list in HTML, with the tag count next to the item
-- TODO: Maybe produce a Context here
renderTagUl :: Tags -> Compiler (String)
renderTagUl = renderTags makeLink (intercalate " ")
  where
    makeLink tag url count _ _ = renderHtml $ H.li $ H.a ! A.href (toValue url) $ toHtml ("(" ++ show count ++ ") " ++ tag)
