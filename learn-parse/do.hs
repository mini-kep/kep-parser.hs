eq a b = if a == b then True else error (show a ++ " not equal to" ++ show b)

-- return
-- ++++++

-- Just an ordinary function with an ordinary type signature:
-- https://stackoverflow.com/questions/38626963/when-to-use-or-not-to-use-return-in-haskells-monad-expression

g = (return 1) :: [Int]

f :: Maybe Int
f = return 1
z = (return 1) :: Maybe Int
boolOne = eq f z


-- interact not meant for human console input
-- ++++++++++++++++++++++++++++++++++++++++++

-- https://stackoverflow.com/a/37206972/1758363
-- may use instead:

interactLine :: (String -> String) -> IO ()
interactLine f = loop
  where
    loop = do
      l <- getLine
      when (l /= "quit") $ putStrLn (f l) >> loop

-- do notation desugaring
-- ++++++++++++++++++++++
w :: Maybe Int
w = do 
   x <- f
   return (x + 1)
boolTwo = eq w (Just 2)
boolThree = eq w $ f >>= \x -> return (x+1)

put = putStrLn
p = do
    put "abc"
    put "def"
p' = put "abc" >> put "def"

main = print $ boolOne && boolTwo && boolThree