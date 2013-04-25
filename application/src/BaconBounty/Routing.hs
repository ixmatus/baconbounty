{-# LANGUAGE 
    OverloadedStrings,
    NoMonomorphismRestriction #-}

module BaconBounty.Routing
    (routes) where

import           Data.ByteString (ByteString)
import           Snap.Snaplet
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           BaconBounty.Application
import           BaconBounty.Handlers

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/static",    serveDirectory "./static/")
         , ("/login",    with auth handleLoginSubmit)
         , ("/logout",   with auth handleLogout)
         , ("/register", with auth handleNewUser)
         ]
