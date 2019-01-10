-- Extract data from semi-structured CSV file

-- Pseudocode for one table:
--   get variable label from table header  
--   get values from table datarows
--   add label to values
--   emit values with label (=datapoints)
--   not done: clean table cell contents
--   not done: kill empty table cells
--   not done: check for duplicates

-- Pseudocode for many tables:
   
-- Read CSV file "gdp.csv" 
-- [+] Split file contents to [Table] data structure 
-- [ ] Repeat for many tables:
--    [+] Assign labels to tables using variable name and unit maps 
--    [+] Extract datapoints from tables
-- [ ] Emit all datapoints 
-- [ ] Save all datapoints  to "data.csv" 

module Main where

import qualified Data.ByteString.Lazy as BL  
import Data.ByteString.Lazy.Char8 (pack)
import Csv (toMatrix)


import Types
import Convert (makeTables)
import Table (getValues)
-- import File (encode)

import Data.Char (ord)
import Data.Csv (encodeWith, encDelimiter, defaultEncodeOptions)
    
myOptions' = defaultEncodeOptions {
      encDelimiter = fromIntegral (ord '\t')
    }

encode' :: [([Char], String, Char, Int, String)] -> BL.ByteString
encode' = encodeWith myOptions'


parse :: String -> String -> IO()
parse sourceFilename outputFilename = do
    -- read file <sourceFilename> 
    -- apply parsing to its contents
    -- save as <outputFilename>
    return ()


list' =  [["GDP"],["subtitle"],["2017","100,6"],["2018","101,3"],["CPI"],["1999","120,2"]]
t' = makeTables list'

-- tab = [TextRow ["GDP"],DataRow ["2017","100,6"]]

-- [Table {headers = [TextRow ["GDP"],TextRow ["subtitle"]], datarows = [DataRow ["2017","100,6"],DataRow ["2018","101,3"]]},Table {headers = [TextRow ["CPI"]], datarows = [DataRow ["1999","120,2"]]}]

-- s' = pack "GDP\n% change to year earlier\n2017\t100,6\t102,5\t102,2\t100,9\n2018\t101,3\t101,9\t101,5\t\n\nGDP, bln run (current price)\n2017\t20549,8\t22035,1\t23948,8\t25503,4\n2018\t22239,4\t24846,6\t27007,2\t\n\n"
-- m' = toMatrix s'
    

main = do 
    Prelude.putStrLn $ show (encode' vs)
    BL.writeFile "data.csv" (encode' vs)  

{- This is resulting  "data.csv: 

GDP_yoy	2017	q	1	100,6
GDP_yoy	2017	q	2	102,5
GDP_yoy	2017	q	3	102,2
GDP_yoy	2017	q	4	100,9
GDP_yoy	2018	q	1	101,3
GDP_yoy	2018	q	2	101,9
GDP_yoy	2018	q	3	101,5
GDP_yoy	2018	q	4	

-}

-- TODO:
-- add an input CSV
-- (make it a ByteString constant)
-- apply parsing
-- save to a file 
-- read file as string and test



-- tab = [TextRow ["GDP"],DataRow ["2017","100,6"]]

-- [Table {headers = [TextRow ["GDP"],TextRow ["subtitle"]], datarows = [DataRow ["2017","100,6"],DataRow ["2018","101,3"]]},Table {headers = [TextRow ["CPI"]], datarows = [DataRow ["1999","120,2"]]}]

-- s' = pack "GDP\n% change to year earlier\n2017\t100,6\t102,5\t102,2\t100,9\n2018\t101,3\t101,9\t101,5\t\n\nGDP, bln run (current price)\n2017\t20549,8\t22035,1\t23948,8\t25503,4\n2018\t22239,4\t24846,6\t27007,2\t\n\n"
-- m' = toMatrix s'



-- parsing: 
--   + extract label
--   + add label to data
--   + export data to file

--data:
--  [ ] read some actual data

-- project:
--  [+] add .cabal
--  [ ] add /tests
--  [+] make a separate repo
--  [ ] use Travis

{-
data Datapoint = Datapoint {
    label :: String,
    year :: a,
    month :: Int,
    freq :: Char,
    value :: a
    }    
    deriving (Show)


    sam = [["GDP"], 
      ["% change to year earlier"],
      ["2017","100,6","102,5","102,2","100,9"]],
      ["2018","101,3","101,9","101,5",""],
      ["GDP, bln run (current price)"],
      ["2017","20549,8","22035,1","23948,8","25503,4"],
      ["2018","22239,4","24846,6","27007,2",""]
    ]
    -}
