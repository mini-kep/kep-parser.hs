-- pairs :: (a -> a -> Bool) -> [a] -> [[a]]
-- pairs _ [] = []
-- pairs _ ([x]) = [x]
-- pairs mustSplit (x:y:zs) = if mustSplit x y then (x:y:zs) else (x:y:zs)
--      where succ = pairs mustSplit


--intersperse _ [] = []
-- intersperse _ [] = []
-- intersperse s (x:xs) = (x : s : intersperse s xs)

f :: (a -> a -> Bool) -> [a] -> [[a]]
f _   []     = []
f _   (x:[])  = (x:y)
f sep (x:y:xs) = if (sep x y) then (x : (succ (y:xs))) else ((x:y) : (succ xs))
    where succ = f sep


