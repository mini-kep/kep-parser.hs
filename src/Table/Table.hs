module Table.Table (toTuples) where

import Table.Make (makeTables)
import Table.Types
import Table.Row 
import Table.Header

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

parseTable :: Table -> Variable
parseTable t = Variable (tableLabel t) (nolabelValues t)

isDefined :: Variable -> Bool
isDefined (Variable (Label (Just _) (Just _)) _) = True
isDefined _ = False

asText :: Label -> String
asText (Label (Just a) (Just b)) = a ++ "_" ++ b
asText _ = "UNKNOWN"

getValues :: Variable -> [DataTuple]
getValues (Variable label values) = [(s, y, f, p, x) | (Value y f p x) <- values]
    where s = asText label

toTuples :: [[LocalString]] -> [DataTuple]
toTuples = concatMap getValues . filter isDefined . map parseTable . makeTables

h1 = [["ВВП", "", ""], ["% change to year earlier", "", ""]]       
d1 = [["2017","100,6","102,5","102,2","100,9"], ["2018","101,3","101,9","101,5",""]]
z = toTuples $ h1 ++ d1
x = Variable (Label (Just "GDP") (Just "yoy")) [Value {year = "2017", freq = 'q', period = 1, amount = "100,6"},Value {year = "2017", freq = 'q', period = 2, amount = "102,5"},Value {year = "2017", freq = 'q', period = 3, amount = "102,2"}]

-- EP: Here is where I start reading about applicative vs monadic parsers.
-- https://habr.com/ru/post/436234/
-- https://stackoverflow.com/questions/7861903/what-are-the-benefits-of-applicative-parsing-over-monadic-parsing
-- iffy-miffy (good!): https://stackoverflow.com/a/7042674/1758363

-- More to read:
-- https://two-wrongs.com/parser-combinators-parsing-for-haskell-beginners.html
-- https://habr.com/ru/post/50337/
-- https://www.futurelearn.com/courses/functional-programming-haskell/0/steps/27222
-- https://two-wrongs.com/parser-combinators-parsing-for-haskell-beginners.html



