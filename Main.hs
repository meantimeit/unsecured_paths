module Main where

import           Control.Monad  (filterM)
import           Data.Foldable  (foldlM)
import           DirectoryTree
import           UnsecuredCheck
import           Utils
import           Utils.Par

-- The program
main :: IO()
main = getPathList
   -- Take STDIN and convert it to a list of DirectoryTree items
   >>= pMapM chkUnsec
   -- map (in parallel) through the list of paths and identify
   -- whether the path is secure or not. Pair up the paths and
   -- boolean secure status
   >>= foldlM fstOnSndIsTrueM []
   -- Remove any items that aren't listed as unsecure
   -- Convert the list to a list of paths again
   >>= putStr . unlines
   -- Combine the lines and output them
