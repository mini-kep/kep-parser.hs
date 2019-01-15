module Table.Header where

import Data.List (intercalate)

import Table.Types
import Table.Label (makeFinder)
import Map (nameMap, unitMap)

getName :: String -> Maybe Tag
getName = makeFinder nameMap

getUnit :: String -> Maybe Tag
getUnit = makeFinder unitMap

headerLines :: Table -> [LocalString]
headerLines t = map (intercalate " ") (headers t)

title :: Table -> LocalString
title t = intercalate " " (headerLines t)

tableLabel :: Table -> Label
tableLabel t = let s = title t in Label (getName s) (getUnit s)         

