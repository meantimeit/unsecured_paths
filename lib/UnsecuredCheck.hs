module UnsecuredCheck where
import           DirectoryTree
import           HtaccessCheck

-- | Take a 'Directory Tree' and return its path if it is an
-- | unsecured path
chkUnsec :: DirectoryTree String -> IO (String, Bool)
chkUnsec (Node p _) = getHtaccessContents p
                  >>= \c -> return (p, not . isSafeHtaccess $ c)

