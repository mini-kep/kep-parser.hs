-- Table -> datapoints

module Table where

import Data.List (isInfixOf)
import Types
import Row

getFormat :: Table -> RowFormat
-- WONTFIX: assume all datarows have same number of columns
getFormat t = colToFormat $ ncol (head (dataRows t)) 

ncol :: [a] -> Int
ncol row = (length head) - 1 

colToFormat :: Int -> String
colToFormat n = case n of 
    4 -> "qqqq"
    5 -> "aqqqq"
    12 -> m12
    17 -> "aqqqq" ++ m12
    where
       m12 = concat (replicate 12 "m")

getValues :: Table -> [(Char, String, Int, String)]
-- todo: must include variable information
getValues t = splitMany (getFormat t) (dataRows t)

