-- Read CSV file, split it to tables, extract values from tables
-- "gdp.csv" -> [Table] -> [Value] -> "readable.csv" 

module Datapoints where

import Row

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
getValues t = split (getFormat t) (dataRows t)

h1 = [["GDP"], ["% change to year earlier"]]       
d1 = [["2017","100,6","102,5","102,2","100,9"], ["2018","101,3","101,9","101,5",""]]
t1 = Table h1 d1
p1 = Datapoint "GDP" "bln_rub" 2017 Nothing (Annual::Frequency) 60000
p2 = Datapoint {name = "GDP", unit = "bln_rub", year = 2017, month = Nothing, freq = Annual, value = 60000}  
vs = getValues(t1)    

-- next: 
--   extract label
--   add label to data
--   export data to file
--   read some actual data
--   add .cabal
--   add .tests
--   make a separate repo
--   use Travis
