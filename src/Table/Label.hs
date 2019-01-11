module Table.Label (makeFinder) where

import Data.List (isInfixOf)
import Map (nameMap, unitMap, Tag)

findAll :: [(String, Tag)]  -> String -> [String]
findAll mapper header = [label | (text, label) <- mapper, text `isInfixOf` header]

-- | Will use just first match and ignore any other matches                                 
findFirst :: [(String, Tag)]  -> String -> Maybe Tag 
findFirst mapper header = case findAll mapper header of 
    [] -> Nothing
    (x:_) -> Just x  

makeFinder :: [(String, Tag)] -> (String -> Maybe Tag)
makeFinder tags = \header -> findFirst tags header 
