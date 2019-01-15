-- Mapping of table header text to variable names.
-- eg "Industrial production" -> "INDPRO"

module Map where

type Tag = String

data Map = Map {
    label :: Tag,
    texts :: [String]  
} deriving (Show)

-- | Convert nameMap and unitMap to lists of tuples
asTuples :: [Map] -> [(String, Tag)]
asTuples maps = concatMap f maps
    where f (Map label texts) = [(tx, label) | tx <- texts] ++ [(label, label)]

nameMap = asTuples [
   Map "GDP" ["Gross domestic product", "ВВП"] ,
   Map "INDPRO" ["Industrial production"] ,
   Map "CPI" ["Consumer price index"]
   ]

unitMap = asTuples [
   Map "rog" ["% change to previous period"] ,
   Map "yoy" ["% change to year earlier"] ,
   Map "bln_rub" ["bln rub"]
   ]