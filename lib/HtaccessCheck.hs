{-# LANGUAGE TemplateHaskell #-}

module HtaccessCheck ( getHtaccessContents
                     , isSafeHtaccess ) where

import           Control.Monad
import           Data.FileEmbed     (embedFile)
import           Data.Text
import           Data.Text.Encoding (decodeUtf8)
import           System.Directory
import           System.IO

-- | Get the contents of the specified htacess file.
-- | If the file doesn't exist, just return nothing
getHtaccessContents :: String -> IO Text
getHtaccessContents dir = append <$> thish <*> parenth
    where thish = textFromFile $ dir ++ "/.htaccess"
          parenth = textFromFile $ dir ++ "/../.htaccess"

-- | Pass in the contents of an htaccess file and determine
-- | whether it protects against attacks. The file must include
-- | PHP engine deactivation as well as blocking access to
-- | common executable files
isSafeHtaccess :: Text -> Bool
isSafeHtaccess h = execSafe || engineSafe
    where execSafe = blockExec `isInfixOf` h
          engineSafe = engineOff `isInfixOf` h

-- | Given a filename, check if it exists and return the
-- | text. Otherwise, just blank text
textFromFile f = doesFileExist f >>= \e -> if e
    then fmap pack (readFile f)
    else mBlankText

-- | Get blank text (lifted in to a monad)
mBlankText :: (Monad m) => m Text
mBlankText = return $ pack ""

blockExec :: Text
blockExec = strip . decodeUtf8 $ $(embedFile "res/block_executable_files")

engineOff :: Text
engineOff = strip . decodeUtf8 $ $(embedFile "res/php_engine_off")


