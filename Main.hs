module Main where

import           Control.Monad          (filterM)
import qualified Control.Monad.Parallel as P (mapM)
import           DirectoryTree
import           HtaccessCheck
import           Utils

-- The program
main :: IO()
main = getPathList
   -- Take STDIN and convert it to a list of DirectoryTree items
   >>= P.mapM chkUnsec
   -- map (in parallel) through the list of paths and identify
   -- whether the path is secure or not. Pair up the paths and
   -- boolean secure status
   >>= filterM sndM
   -- Remove any items that aren't listed as unsecure
   >>= mapM fstM
   -- Convert the list to a list of paths again
   >>= putStr . unlines
   -- Combine the lines and output them

-- | Take a 'Directory Tree' and return its path if it is an
-- | unsecured path
chkUnsec :: DirectoryTree String -> IO (String, Bool)
chkUnsec (Node p _) = getHtaccessContents p
                  >>= \c -> return (p, not . isSafeHtaccess $ c)