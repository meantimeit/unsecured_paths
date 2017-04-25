import           Control.Monad  (filterM)
import           Data.Foldable  (foldlM)
import           DirectoryTree
import           Test.HUnit
import           UnsecuredCheck
import           Utils
import           Utils.Par      (pMapM)
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
runTest ls = (return . fromStringList . lines $ ls)
         >>= pMapM chkUnsec
         >>= foldlM fstOnSndIsTrueM []
         >>= return . unlines

getScenarios :: [FilePath] -> [FilePath] -> IO [(ActualSrc, Expected)]
getScenarios s e = zipM (readFiles s) (readFiles e)

scenarios :: [FilePath]
scenarios = [ "test/cases/no_matches"
            , "test/cases/one_match_no_problems"
            , "test/cases/one_nested_set_of_bad_dirs"
            , "test/cases/prevent_a1_being_categorised_as_subfolder_of_a"
            , "test/cases/two_nested_sets_of_bad_dirs"
            , "test/cases/can_protect_directories_one_level_up" ]

expected :: [FilePath]
expected = map (++ "_expected") scenarios
