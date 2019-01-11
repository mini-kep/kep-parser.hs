module Table.Make (makeTables) where

import Data.List.Split
import Table.Types

isYear x = elem (take 2 x) ["19", "20"]
isYearRow row = isYear $ head row
toRow r = if isYear $ head r then DataRow r else TextRow r

-- | Split a list by checking a condition of neighboring elements
-- Вased on https://stackoverflow.com/questions/14403293/need-to-partition-a-list-into-lists-based-on-breaks-in-ascending-order-of-elemen
splitWhen' condition =  split . keepDelimsR $ whenElt condition
pan xs = zip xs ((drop 1 xs) ++ [TextRow ["---"]])
sublist condition = map (map fst) . splitWhen' condition . pan

isEndOfTable (DataRow _, TextRow _) = True
isEndOfTable otherwise  = False
-- may use filter filter :: (a -> Bool) -> [a] -> [a] 
groupRowsByTable = init . (sublist isEndOfTable)

toTable :: [Row] -> Table
toTable rows = Table a b 
    where 
        a = [x | (TextRow x)<-rows]
        b = [x | (DataRow x)<-rows]

makeTables = map toTable . groupRowsByTable . map toRow
