-- Little testing framework

module Microtest where

add text x = text ++ "\n    " ++ show x
echo msg a b = foldl add (msg ++ ":") [a, b]
msg a b = echo (if a==b then "Passed" else "Failed") a b
eq a b = putStrLn $ msg a b 

-- WONTFIX: cannot add <if - error> constructs, messes types
-- MAYBE: add type information to echo