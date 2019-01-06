-- Split rows to values

module Row (splitMany) where

import Microtest

type RowFormat = [Char]

count :: Char -> String -> Int
count letter str = length $ filter (== letter) str

expand :: RowFormat -> [(Char, Int)]
expand pat = [(c, count c (take (i+1) pat)) | (c, i) <- zip pat [0..]]

splitOne :: [(Char, Int)] -> [a] -> [(a, Char, Int, a)]
splitOne pattern row = zipWith merge pattern (tail row)
    where 
        merge (freq, period) x = (year, freq, period, x)
        year = head row

splitMany :: RowFormat -> [[a]] -> [(a, Char, Int, a)]
splitMany fmt rows = (concat $ map f' rows)
    where 
        f' = splitOne (expand fmt)

-- todo: convert to unit test        
main = do 
    putStrLn m1
    putStrLn m2
    where 
        m1 = msg (splitMany "ahh" [[2017, 100, 50, 50], [2018, 120, 40, 80]]) [('a',2017,1,100),('h',2017,1,50),('h',2017,2,50),('a',2018,1,120),('h',2018,1,40),('h',2018,2,80)]
        m2 = msg (splitMany "aqqqq" [[2020, 100, 10, 40, 25, 25]]) [('a',2020,1,100),('q',2020,1,10),('q',2020,2,40),('q',2020,3,25),('q',2020,4,25)]
