-- Table -> datapoints

module Table where

import Data.List (intercalate)

import Microtest
import Row
import qualified Label

data Table = Table {
    headerRows :: [[String]],
    dataRows :: [[String]]
    }
    deriving (Show)    

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

getValues :: Table -> [(Char, String, Int, String)]
-- todo: must include variable information
getValues t = splitMany (getFormat t) (dataRows t)

spaces = intercalate " "

titles :: Table -> [String]
titles t = map spaces (headerRows t)

title :: Table -> String
title t = spaces (titles t)

name :: Table -> Maybe String
name t = Label.getName $ title t

unit :: Table -> Maybe String
unit t = Label.getUnit $ title t

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
