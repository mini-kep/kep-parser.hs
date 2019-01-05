-- Extract data from semi-structured CSV file

-- Read "gdp.csv" 
-- Split to [Table] 
-- Assign labels to tables using definitions
-- + Extract datapoints from tables
-- + Save "data.csv" 

module Main where

import qualified Data.ByteString.Lazy as BL    
import Data.Csv (encode)
    
import Datapoints

h1 = [["GDP"], ["% change to year earlier"]]       
d1 = [["2017","100,6","102,5","102,2","100,9"], ["2018","101,3","101,9","101,5",""]]
t1 = Table h1 d1
vs = getValues(t1)
main = do 
    Prelude.putStrLn $ show (encode vs)
    BL.writeFile "data.csv" (encode vs)  

--main :: IO ()
--main = putStrLn "Hello, Haskell!"


-- next: 
--   extract label
--   add label to data
--   export data to file
--   read some actual data
--   + add .cabal
--   add .tests
--   make a separate repo
--   use Travis
