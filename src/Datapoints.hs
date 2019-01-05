-- Table -> datapoints

module Datapoints where

import Data.List (isInfixOf)
import Row

-- WONTFIX: same as module type
type Row = [String]
type Rows = [Row]
type RowFormat = [Char]

data Table = Table {
    headerRows :: Rows,
    dataRows :: Rows
    }
    deriving (Show)    

-- WONTFIX: assume all datarows have same number of columns
ncol :: [[a]] -> Int
ncol rows = (length $ head rows) - 1 

colToFormat :: Int -> String
colToFormat n = case n of 
    4 -> "qqqq"
    5 -> "aqqqq"
    12 -> m12
    17 -> "aqqqq" ++ m12
    where
       m12 = concat (replicate 12 "m")

getFormat :: Table -> RowFormat
getFormat t = colToFormat $ ncol (dataRows t) 

getValues :: Table -> [(Char, String, Int, String)]
-- todo: must include variable information
getValues t = splitMany (getFormat t) (dataRows t)

data Map = Map 
    { label :: String,
      spells :: [String]  
    } deriving (Show)

nameMap = [
      Map "GDP" ["Gross domestic product"]
    , Map "INDPRO" ["Industrial production"]
    ]

-- converts nameMap and unitMap to plain lists of tuples
asTuples :: [Map] -> [(String, String)]   
asTuples maps = concatMap f maps
    where f (Map label spells) = [(spell, label) | spell <- spells]

findAll :: [(String, String)] -> String -> [String]
findAll mapper header = [label | tup@(spell, label) <- mapper,  
                                 spell `isInfixOf` header]
-- Assumption: will use just first match                                 
findFirst mapper header = case findAll mapper header of 
    [] -> Nothing
    (x:_) -> Just x  

makeFinder maps = \header -> findFirst (asTuples maps) header 
getLabel = makeFinder nameMap
b = getLabel "Gross domestic product"