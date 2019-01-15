module HUnitTest where

    import Data.List
    import Test.Tasty
    import Test.Tasty.HUnit
    import Test.Tasty.Hspec
    import Test.Tasty.QuickCheck
    
    -- HUnit test case
    unit_listCompare :: IO ()
    unit_listCompare = 1 @?= 2