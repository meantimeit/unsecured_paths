module Utils where

-- | Split a list of things in to multiple lists using a delimiter
split :: (Eq a) => a -> [a] -> [[a]]
split _ [] = []
split delimiter a = foldr f [[]] a
    where f c l@(x:xs) | c == delimiter = []:l
                       | otherwise = (c:x):xs

-- | Split on a given delimiter with trimmage
splitWith :: (Eq a) => a -> [a] -> [[a]]
splitWith = (.) <$> split <*> lTrim

-- | Trim a delimiter(s) from the beginning of a list
-- | In most cases, this will be to remove a character(s) from the
-- | beginning of a string
lTrim :: (Eq a) => a -> [a] -> [a]
lTrim delim [] = []
lTrim delim xxs@(x:xs)
    | x == delim = lTrim delim xs
    | otherwise = xxs

-- | Get the second item from a tuple but lifted in to
-- | a monad
sndM :: (Monad m) => (a,b) -> m b
sndM = return . snd

-- | Get the first item from a tuple but lifted in to
-- | a monad
fstM :: (Monad m) => (a,b) -> m a
fstM = return . fst

-- | Zip 2 monadic lists
zipM :: Monad m => m [a] -> m [b] -> m [(a,b)]
zipM ma mb = do
    a <- ma
    b <- mb
    let z = zip a b
    return z

-- | Take a list of filepaths and map their contents
readFiles :: [String] -> IO [String]
readFiles = mapM readFile