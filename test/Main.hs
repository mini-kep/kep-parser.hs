-- Tests.hs
import Test.QuickCheck

prop_reverseReverse :: [Int] -> Bool
prop_reverseReverse xs = reverse (reverse xs) == xs

-- quickCheckAll generates test cases for all 'prop_*' properties
main = $(quickCheckAll)