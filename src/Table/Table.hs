module Table.Table (getValues, makeTables, Value) where

import Table.Make (makeTables, Table(..))

import Table.Row (splitMany, addLabel, Value, RowFormat)
import Table.Header (getLabel)

getFormat :: Table -> RowFormat
getFormat t = colToFormat $ ncol t 

ncol :: Table -> Int
ncol t = maximum $ map count $ datarows t -- longest row defines format
    where count row = (length row) - 1 

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

nolabelValues :: Table -> [Value]
nolabelValues t = splitMany (getFormat t) (datarows t)

getValues :: Table -> [Value]
getValues t = map labeller (nolabelValues t)
    where labeller = addLabel (getLabel t)