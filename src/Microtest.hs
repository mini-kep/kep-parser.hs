-- Little testing framework

module Microtest where

sh a b = "\n" ++ show a ++ "\n" ++ show b
eq a b = putStrLn (if a==b then "Passed" else "Failed:" ++ sh a b)

-- WONTFIX: cannot add <if - error> constructs, messes types