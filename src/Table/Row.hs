-- Split rows to values

module Table.Row (splitMany) where

type RowFormat = [Char]
type RowPattern = [(Char, Int)]
type Cell = String        
type Value = [(Cell, Char, Int, Cell )]

count :: Char -> String -> Int
count letter str = length $ filter (== letter) str

expand :: RowFormat -> RowPattern
expand pat = [(c, count c (take (i+1) pat)) | (c, i) <- zip pat [0..]]

--split':: RowPattern -> Cell -> [Cell] -> [Value]    
split' pattern year values = zipWith merge pattern values
    where merge (freq, period) x = (year, freq, period, x)

--splitOne' :: RowPattern -> [Cell] -> [Value]
splitOne' pattern row = split' pattern (head row) (tail row)

--splitMany :: RowFormat -> [[Cell]] -> [Value]
splitMany fmt rows = concatMap (splitOne' $ expand fmt) rows

-- todo: convert to unit test  
      
-- main = do 
--     putStrLn $ msg a b
--     putStrLn $ msg c d
--     where 
--         a = splitMany "ahh" [[2017, 100, 50, 50], [2018, 120, 40, 80]]
--         b = [(2017,'a',1,100),(2017,'h',1,50),(2017,'h',2,50),(2018,'a',1,120),(2018,'h',1,40),(2018,'h',2,80)]
--         c = splitMany "aqqqq" [[2020, 100, 10, 40, 25, 25]]
--         d = [(2020,'a',1,100),(2020,'q',1,10),(2020,'q',2,40),(2020,'q',3,25),(2020,'q',4,25)]
