module Types where

data Table = Table {
    headerRows :: [[String]],
    dataRows :: [[String]]
    }
    deriving (Show)  

