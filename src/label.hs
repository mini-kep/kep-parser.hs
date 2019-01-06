module Label (getName, getUnit) where

import Data.List (isInfixOf)
import Microtest

data Map = Map  
    { label :: String,
      texts :: [String]  
    } deriving (Show)

nameMap = [
      Map "GDP" ["Gross domestic product", "ВВП"]
    , Map "INDPRO" ["Industrial production"]
    ]

unitMap = [
      Map "rog" ["% change to previous period"],
      Map "yoy" ["% change to previous year"]
    ]
    
-- convert nameMap and unitMap to lists of tuples
asTuples :: [Map] -> [(String, String)]
asTuples maps = concatMap f maps
    where f (Map label texts) = [(t, label) | t <- texts]

findAll :: [(String, String)] -> String -> [String]
findAll mapper header = [label | tup@(spell, label) <- mapper,
                         spell `isInfixOf` header]

-- assumption: will use just first match                                 
findFirst mapper header = case findAll mapper header of 
    [] -> Nothing
    (x:_) -> Just x  

makeFinder map = \header -> findFirst (asTuples map) header 

getName = makeFinder nameMap
getUnit = makeFinder unitMap

main :: IO ()
main = do 
    eq (Just "GDP") (getName title)
    eq (Just "rog") (getUnit title)
    where 
        title = "Gross domestic product, % change to previous period"
