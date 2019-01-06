-- Extract data from semi-structured CSV file

-- Pseudocode:
   
-- Read CSV file "gdp.csv" 
-- Split file contents to [Table] 
-- Repeat for many tables:
--   Assign labels to tables using variable name and unit maps 
--   Extract datapoints from tables
--   Add table label to datapoints
-- Emit all datapoints 
-- Save "data.csv" 

module Main where


import qualified Data.ByteString.Lazy as BL  

import Types
import Table (getValues)
-- import File (encode)

import Data.Char (ord)
import Data.Csv (encodeWith, encDelimiter, defaultEncodeOptions)
    
myOptions' = defaultEncodeOptions {
      encDelimiter = fromIntegral (ord '\t')
    }

encode' :: [([Char], String, Char, Int, String)] -> BL.ByteString
encode' = encodeWith myOptions'


h1 = [["ВВП"], ["% change to year earlier"]]       
d1 = [["2017","100,6","102,5","102,2","100,9"], ["2018","101,3","101,9","101,5",""]]
t1 = Table h1 d1
vs = getValues(t1)

parse :: String -> String -> IO()
parse sourceFilename outputFilename = do
    -- read file <sourceFilename> 
    -- apply parsing to its contents
    -- save as <outputFilename>
    return ()

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
