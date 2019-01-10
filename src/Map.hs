-- Mapping of table header text to variable names.
-- eg "Industrial production" -> "INDPRO"

module Map where
    
data Map = Map {
    label :: String,
    texts :: [String]  
} deriving (Show)

nameMap = [
   Map "GDP" ["Gross domestic product", "ВВП"] ,
   Map "INDPRO" ["Industrial production"] ,
   Map "CPI" ["Consumer price index"]
   ]

unitMap = [
   Map "rog" ["% change to previous period"] ,
   Map "yoy" ["% change to year earlier"] ,
   Map "bln_rub" ["bln rub"]
   ]