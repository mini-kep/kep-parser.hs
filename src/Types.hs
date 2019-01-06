module Types where
    
-- WONTFIX: same as module name
type Row = [String]
type Rows = [Row]
type RowFormat = [Char]

data Table = Table {
    headerRows :: Rows,
    dataRows :: Rows
    }
    deriving (Show)    
