module Utils.Test where

import           Test.HUnit

-- | Take a triple (consisting of scenario name, actual result, expected result) of
-- | test data and convert it to a HUnit test case for the test runner
saeToTestCase :: (Eq a, Show a) => (String, a, a) -> Test
saeToTestCase (s, a, e) = TestCase $ assertEqual s e a

fPassThrough :: Monad m => (a -> m b) -> a -> m a
fPassThrough f a = f a >> return a

dbgPrnt :: Show a => a -> IO a
dbgPrnt = fPassThrough print