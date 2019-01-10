-- Split rows to values

module Table.Row (splitMany, addLabel, tup, Value, RowFormat) where

import Table.Label (Label)    
type RowFormat = [Char]
type RowPattern = [(Char, Int)]

count :: Char -> String -> Int
count letter str = length $ filter (== letter) str

expand :: RowFormat -> RowPattern
expand pat = [(c, count c (take (i+1) pat)) | (c, i) <- zip pat [0..]]

data Value = Value {    
    label :: Maybe Label,
    year :: String, 
    freq :: Char, 
    period :: Int, 
    amount :: String
    } deriving (Show)

split :: RowPattern -> String -> [String] -> [Value]    
split pattern year values = zipWith merge pattern values
    where merge (freq, period) x = Value Nothing year freq period x

splitOne :: RowPattern -> [String] -> [Value]
splitOne pattern row = split pattern (head row) (tail row)

splitMany :: RowFormat -> [[String]] -> [Value]
splitMany fmt rows = concatMap (splitOne $ expand fmt) rows

addLabel :: Label -> Value -> Value
addLabel label (Value _ y f p x) = Value (Just label) y f p x

tup (Value (Just label) year f p x) = (label, year, f, p, x)