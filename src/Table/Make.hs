module Table.Make (makeTables, Table(..)) where

import Data.List.Split

data Row = DataRow [String] | TextRow [String] deriving (Show)
data Table = Table {
    headers :: [[String]],
    datarows :: [[String]]
    }
    deriving (Show)  

isYear x = elem (take 2 x) ["19", "20"]
isYearRow row = isYear $ head row
toRow r = if isYear $ head r then DataRow r else TextRow r

-- | Split a list of condition checking neighboring elements
-- based on https://stackoverflow.com/questions/14403293/need-to-partition-a-list-into-lists-based-on-breaks-in-ascending-order-of-elemen
splitWhen' condition =  split . keepDelimsR $ whenElt condition
pan xs = zip xs ((drop 1 xs) ++ [TextRow ["---"]])
sublist condition = map (map fst) . splitWhen' condition . pan
isEndOfTable (DataRow _, TextRow _) = True
isEndOfTable otherwise  = False
groupRowsByTable = init . (sublist isEndOfTable)

toTable :: [Row] -> Table
toTable rows = Table a b 
    where 
        a = [x | (TextRow x)<-rows]
        b = [x | (DataRow x)<-rows]

makeTables = map toTable . groupRowsByTable . map toRow

-- move to test
-- list' =  [["GDP"],["subtitle"],["2017","100,6"],["2018","101,3"],["CPI"],["1999","120,2"]]
-- t' = makeTables list'
