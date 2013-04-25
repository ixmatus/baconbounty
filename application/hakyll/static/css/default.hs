{-# LANGUAGE OverloadedStrings #-}
module Main where

import Clay hiding (i, s, id)
import Clay.Font as F
import Data.Monoid
import Prelude hiding (div, span)
import qualified Data.Text.Lazy    as Lazy
import qualified Data.Text.Lazy.IO as Lazy

main :: IO ()
main = Lazy.putStr (renderWith compact [] theStylesheet)

-- Main stylesheet pulling it all together
theStylesheet :: Css
theStylesheet = do

    blockquote ? 
        do fontSizeCustom medium
    docMain
    navBar
    mainNav
    docHeaders
    docTabularium
    docFooter

docMain :: Css
docMain = do
    p ? do 
           fontSize (pct 160)
           fontFamily ["museo-sans", "Verdana"] [sansSerif]
           fontWeight lighter
           lineHeight (px 30)
           color "#4b4a42"
           letterSpacing (px 1)
    ".description" <> ".date" ?
        do color "#808080"
    ".container" ?
        do backgroundColor "#FFF"
    ".inline-block" ?
        do display inline
    ".nav-fixed" ?
        do backgroundColor transparent
           width (pct 100)
           marginBottom (px 20)
    ".nav-centered" ?
        do margin 0 auto 0 auto
           width (px 350)
    ".zero-bottom-margin" ?
        do marginBottom 0
           "-webkit-border-top-radius" -: "0"
           "-moz-border-radius" -: "0"
           borderRadius (px 0) (px 0) (px 0) (px 0)
    ".zero-top-borders" ?
        do "-webkit-border-top-radius" -: "0"
           "-moz-border-radius" -: "0"
           borderRadius (px 0) (px 0) (px 0) (px 0)
    ".hero-unit" |> ".centered-text" ?
        do margin 0 auto 0 auto
           textAlign (alignSide sideCenter)

-- Nav bar css
navBar :: Css
navBar = do
    ".navbar" ?
        do fontSize (px 15)
           paddingLeft (px 15)
    ".navbar" ?
        ".nav" |> li |> ".dropdown-menu::before" ?
        ".dropdown-menu::after" ?
        do border       none 0 none
           borderLeft   none 0 none
           borderRight  none 0 none
           borderBottom none 0 none
    ".navbar" ? ".brand" ?
        do backgroundColor "#87CEFA"
           textShadow 0 (px 1) 0 "#C4E9FE"
           color "#050505"
    ".navbar-inner" ?
        do backgroundImage none
    ".nav" ? ".dropdown-menu" ?
        do borderBottomRightRadius (px 6) (px 6)
           borderBottomLeftRadius (px 6) (px 6)
           "-webkit-border-radius" -: "0 0 6px 6px"
           "-moz-border-radius" -: "0 0 6px 6px"

mainNav :: Css
mainNav = do
    "#main-nav" ?
        do width (px 140)
           backgroundColor "#FFF"
    ".nav-icon" ?
        do paddingRight (px 5)
--    "#main-nav" |> li |> "a:hover" ?
--        do backgroundColor "#FFD973"

-- Header specific rules
docHeaders :: Css
docHeaders = do
    h1 ? do fontSize (px 50)
    h2 ? do fontSize (px 40)
            color "#424242"
    h3 ? do fontSize (px 30)
            color "#585858"
    h4 ? do fontSize (px 20)
            color "#585858"
    h5 ? do fontSize (px 16)
            color "#585858"
    ".tagheading" ?
         do color "#0F4FA8"

-- Tabularium Rules
docTabularium :: Css
docTabularium = do
    ".tabularium-items" |> tbody |> tr |> "td:first-child" ?
        do width (px 100)
    ".aitems" ?
        do paddingBottom (px 15)

-- Footer rules
docFooter :: Css
docFooter = do
    footer ?
        do paddingTop (px 25)
    ".footnote" ?
        do fontSizeCustom F.small
    ".footnote-header" ?
        do fontSizeCustom F.small
           top (px (-15))
