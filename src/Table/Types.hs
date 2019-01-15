module Table.Types (LocalString,
                    Tag, 
                    Row(..), Table(..), 
                    RowFormat, RowPattern, 
                    Label(..),
                    Value(..), 
                    Variable(..),
                    DataTuple
                    )  where 

import Map (Tag) 

type LocalString = String

data Row = DataRow [LocalString] | TextRow [LocalString] deriving (Show)

data Table = Table {
    headers :: [[LocalString]],
    datarows :: [[LocalString]]
    } deriving (Show)  

type RowFormat = [Char]
type RowPattern = [(Char, Int)]

data Value = Value {    
    year :: LocalString, 
    freq :: Char, 
    period :: Int, 
    amount :: LocalString
    } deriving (Show)

data Label = Label (Maybe Tag) (Maybe Tag) deriving (Show)

data Variable = Variable Label [Value] deriving (Show)

type DataTuple = (String, LocalString, Char, Int, LocalString)