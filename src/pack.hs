import Data.List
import Data.Text (isPrefixOf)
import Data.ByteString.Lazy.Char8 (pack)
import Csv (toMatrix)

s' = pack "GDP\n% change to year earlier\n2017\t100,6\t102,5\t102,2\t100,9\n2018\t101,3\t101,9\t101,5\t\n\nGDP, bln run (current price)\n2017\t20549,8\t22035,1\t23948,8\t25503,4\n2018\t22239,4\t24846,6\t27007,2\t\n\n"
m' = toMatrix s'

list' =  [["GDP"],["% change to year earlier"],["2017","100,6","102,5","102,2","100,9"],["2018","101,3","101,9","101,5",""],["GDP, bln run (current price)"],["2017","20549,8","22035,1","23948,8","25503,4"],["2018","22239,4","24846,6","27007,2",""]]

-- could use Data.Text.isPrefixOf, but type mismatch
isYear s = case take 2 s of
    "20" -> True
    "19" -> True
    _ -> False

-- isYear "2012" == True
-- isYear "abc" == False   

isYearRow row = isYear $ head row
isTextRow row = not $ isYearRow

groupBy'                 :: (a -> a -> Bool) -> [a] -> [[a]]
groupBy' _  []           =  []
groupBy' eq (x:xs)       =  (x:ys) : groupBy' eq zs
                            where (ys,zs) = span (eq x) xs

pairs mustSplit [] = []
pairs mustSplit x:[] = []
pairs mustSplit x:y:zs = if mustSplit x y then x : pairs (y:zs) else (x:y) : (pairs zs)

rowGrouper a b = if isYearRow a /= True && isYearRow b /= False then False else True
    
g' = groupBy rowGrouper list'


main = print $ length g'