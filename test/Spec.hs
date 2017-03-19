import           Control.Monad    (filterM)
import           DirectoryTree
import           Test.HUnit
import           UnsecuredCheck
import           Utils
import           Utils.Test

type ActualSrc = String
type Expected = String

main :: IO Counts
main = do
    scens <- getScenarios scenarios expected
    res <- mapM runTestM scens
    let tlist = fmap saeToTestCase res
    runTestTT $ TestList tlist

runTestM (s, e) = do
    a <- runTest s
    return (s, a, e)

-- Run the tests against the provided paths
runTest :: String -> IO String
runTest ls = (return $ (fromStringList . lines) ls)
         >>= mapM chkUnsec
         >>= filterM sndM
         >>= mapM fstM
         >>= return . unlines

getScenarios :: [FilePath] -> [FilePath] -> IO [(ActualSrc, Expected)]
getScenarios s e = zipM (readFiles s) (readFiles e)

scenarios :: [FilePath]
scenarios = [ "test/no_matches"
            , "test/one_match_no_problems"
            , "test/one_nested_set_of_bad_dirs"
            , "test/prevent_a1_being_categorised_as_subfolder_of_a"
            , "test/two_nested_sets_of_bad_dirs" ]

expected :: [FilePath]
expected = map (++ "_expected") scenarios
