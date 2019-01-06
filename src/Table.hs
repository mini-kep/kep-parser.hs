-- Table with header rows and data rows

module Table where

import Microtest

import Types
import Row
import Header
import qualified Label  

getFormat :: Table -> String
-- WONTFIX: assume all datarows have same number of columns
getFormat t = colToFormat $ ncol (head (dataRows t)) 

ncol :: [a] -> Int
ncol row = (length row) - 1 

colToFormat :: Int -> String
colToFormat n = case n of 
    4 -> "qqqq"
    5 -> "aqqqq"
    12 -> m12
    17 -> "aqqqq" ++ m12
    where
       m12 = concat (replicate 12 "m")

--nolabelValues :: Table -> [(a, Char, Int, a)]
nolabelValues t = splitMany (getFormat t) (dataRows t)

--addLabel ::  [(a, Char, Int, a)] -> String -> [(String, a, Char, Int, a)]
addLabel values lab = [(lab, y, f, p, x) | (y, f, p, x) <- values]

--getValues :: Table -> [(String, a, Char, Int, a)]
getValues t = addLabel (nolabelValues t) $ label (name t) (unit t)

-- todo: convert to unit test
h1 = [["ВВП", "", ""], ["% change to year earlier", "", ""]]       
d1 = [["2017","100,6","102,5","102,2","100,9"], ["2018","101,3","101,9","101,5",""]]
t1 = Table h1 d1
vs = getValues(t1)
n' = name(t1)
u' = unit(t1)

main :: IO ()
main = do 
    eq (Just "GDP") n'
    eq (Just "yoy") u'
