module DirectoryTree ( fromStringList
                     , getPathList
                     , DirectoryTree(..) ) where

import           Data.Function (on)
import           Data.List     (isPrefixOf, sort)
import           Utils

-- | The main data type for this program. The DirectoryTree
-- | represents a directory that is a path (a) and a list of
-- | subtrees beneath it
data DirectoryTree a = Node a [DirectoryTree a]
    deriving (Show, Eq)

-- | Make DirectoryTree an instance of Functor
instance Functor DirectoryTree where
    fmap f (Node a []) = Node (f a) []
    fmap f (Node a bs) = Node (f a) (map (fmap f) bs)

-- | Take a list of strings and convert them in to a nested
-- | directory tree
-- | Before using foldl, it sorts the list of strings to ensure that
-- | the ordering is correct
fromStringList :: [String] -> [DirectoryTree String]
fromStringList = foldl addNode [] . sortedNodes

-- | Get the contents of STDIN and convert to a list of strings
-- | split by line
getPathList :: IO [DirectoryTree String]
getPathList = fmap (fromStringList . lines) getContents

-- | Given a list of Directories an a new 'node', add this in somewhere
-- | appropriate. If the new node isn't a child of an existing node, it
-- | simply appends it to the end of the list
addNode :: [DirectoryTree String] -> DirectoryTree String -> [DirectoryTree String]
addNode [] a          = [a]
addNode (n@(Node nn nl):ns) a
    | a `isDirectChildOf` n = appendChild n a:ns
    | a `isChildOf` n       = Node nn (addNode nl a):ns
    | otherwise             = n:addNode ns a

-- | Simple add a node to the sub-nodes array for a parent node
appendChild :: DirectoryTree a -> DirectoryTree a -> DirectoryTree a
appendChild (Node a b) c = Node a (b ++ [c])

-- | Detect whether a given node could actually live as a child of another
-- | node
isChildOf :: DirectoryTree String -> DirectoryTree String -> Bool
isChildOf = flip isPrefixOf `on` (splitWith '/' . getPath)

-- | Detect whether a given node could actually live as a child of another
-- | node
isDirectChildOf :: DirectoryTree String -> DirectoryTree String -> Bool
c@(Node child _) `isDirectChildOf` p@(Node parent _) = isPrefix && isDirect
    where isPrefix         = p `isChildOf` c
          isDirect         =  (parentPathLength + 1) == childPathLength
          parentPathLength = numDirs parent
          childPathLength  = numDirs child

-- | Take a list of strings and return a sorted list of Nodes
sortedNodes :: Ord a => [a] -> [DirectoryTree a]
sortedNodes = map fromPath . sort

-- | Calculate the number of path components in a 'path' string
numDirs :: String -> Int
numDirs = length . splitWith '/'

-- | Convert a to a DirectoryTree of type a. Conceivably this is
-- | a String converted in to a DirectoryTree String
fromPath :: a -> DirectoryTree a
fromPath a = Node a []

getPath :: DirectoryTree a -> a
getPath (Node a _) = a
