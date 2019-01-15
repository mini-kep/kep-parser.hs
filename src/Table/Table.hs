module Table.Table (getValues, makeTables) where

import Table.Make (makeTables, Table(..))
import qualified Table.Row    as Row
import qualified Table.Header as Header
import qualified Table.Label  as Label 
    
getFormat :: Table -> String
-- WONTFIX: assume all datarows have same number of columns
getFormat t = colToFormat $ ncol (head (datarows t)) 

ncol :: [a] -> Int
ncol row = (length row) - 1 

colToFormat :: Int -> String
colToFormat n = case n of
    1 -> "a"
    2 -> "hh" 
    4 -> "qqqq"
    5 -> "aqqqq"
    12 -> m12
    17 -> "aqqqq" ++ m12
    where
        m12 = concat (replicate 12 "m")


--nolabelValues :: Table -> [(a, Char, Int, a)]
nolabelValues t = Row.splitMany (getFormat t) (datarows t)

--addLabel ::  [(a, Char, Int, a)] -> String -> [(String, a, Char, Int, a)]
addLabel lab values  = [(lab, y, f, p, x) | (y, f, p, x) <- values]

--getValues :: Table -> [(String, a, Char, Int, a)]
getValues t = addLabel (Header.getLabel t) (nolabelValues t)

-- todo: convert to unit test
h1 = [["ВВП", "", ""], ["% change to year earlier", "", ""]]       
d1 = [["2017","100,6","102,5","102,2","100,9"], ["2018","101,3","101,9","101,5",""]]
t1 = Table h1 d1
vs = getValues(t1)
-- n' = name(t1)
-- u' = unit(t1)

-- main :: IO ()
-- main = do 
--     eq (Just "GDP") n'
--     eq (Just "yoy") u'    