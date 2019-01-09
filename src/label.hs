module Label (getName, getUnit) where

import Data.List (isInfixOf)
import qualified Microtest

data Map = Map  
    { label :: String,
      texts :: [String]  
    } deriving (Show)

nameMap = [
      Map "GDP" ["Gross domestic product", "ВВП"]
    , Map "INDPRO" ["Industrial production"]
    , Map "CPI" ["Consumer price index"]
    ]

unitMap = [
      Map "rog" ["% change to previous period"],
      Map "yoy" ["% change to year earlier"],
      Map "bln_rub" ["bln rub"]
    ]
    
-- convert nameMap and unitMap to lists of tuples
asTuples :: [Map] -> [(String, String)]
asTuples maps = concatMap f maps
    where f (Map label texts) = [(tx, label) | tx <- texts] ++ [(label, label)]

findAll :: [(String, String)] -> String -> [String]
findAll mapper header = [lab | (tx, lab) <- mapper, tx `isInfixOf` header]

-- assumption: will use just first match                                 
findFirst mapper header = case findAll mapper header of 
    [] -> Nothing
    (x:_) -> Just x  

makeFinder map = \header -> findFirst (asTuples map) header 
getName = makeFinder nameMap
getUnit = makeFinder unitMap

-- move to test
main :: IO ()
main = do 
    Microtest.eq (Just "GDP") (getName title)
    Microtest.eq (Just "rog") (getUnit title)
    where 
        title = "Gross domestic product, % change to previous period"
