module Utils.Par where

import           Control.Monad.IO.Class (liftIO)
import           Control.Monad.Par.IO   (runParIO)

-- | Run a mapM operation using runParIO to take advantage
-- | of monad-par's parallel processing operations
pMapM :: (a -> IO b) -> [a] -> IO [b]
pMapM f a = runParIO (liftIO $ mapM f a)