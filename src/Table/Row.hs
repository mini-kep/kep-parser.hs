-- Split row to values

module Table.Row (splitMany) where

import Table.Types

count :: Char -> String -> Int
count letter str = length $ filter (== letter) str

expand :: RowFormat -> RowPattern
expand pat = [(c, count c (take (i+1) pat)) | (c, i) <- zip pat [0..]]

split :: RowPattern -> LocalString -> [LocalString] -> [Value]    
split pattern year values = zipWith merge pattern values
    where merge (freq, period) x = Value year freq period x

splitOne :: RowPattern -> [LocalString] -> [Value]
splitOne pattern row = split pattern (head row) (tail row)        

splitMany :: RowFormat -> [[LocalString]] -> [Value]
splitMany fmt rows = concatMap (splitOne $ expand fmt) rows
