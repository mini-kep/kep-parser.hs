module Table.Label (getName, getUnit, composeLabel, Label) where

import Data.List (isInfixOf)
import Map (nameMap, unitMap, Tag)

type TagDict = [(String, Tag)] 

findAll :: TagDict -> String -> [String]
findAll mapper header = [label | (text, label) <- mapper, text `isInfixOf` header]

-- | Will use just first match and ignore any other matches                                 
findFirst :: TagDict -> String -> Maybe Tag 
findFirst mapper header = case findAll mapper header of 
    [] -> Nothing
    (x:_) -> Just x  

makeFinder :: TagDict -> (String -> Maybe Tag)
makeFinder tags = \header -> findFirst tags header 

getName :: String -> Maybe Tag
getName = makeFinder nameMap

getUnit :: String -> Maybe Tag
getUnit = makeFinder unitMap

type Label = String 
composeLabel :: Maybe Tag -> Maybe Tag -> Label
composeLabel (Just name) (Just unit) = name ++ "_" ++ unit
composeLabel Nothing (Just unit)     = "..._" ++ unit
composeLabel (Just name) Nothing     = name ++ "_..."
composeLabel _ _                     = "UNKNOWN"
