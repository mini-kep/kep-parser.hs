module Main where

import qualified Table.Table as T

import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V
import Data.ByteString.Lazy.Char8 (pack, unpack) 
import Data.Char (ord)
import Data.Csv 

type ByteString = BL.ByteString 
type ByteStringMatrix = V.Vector (V.Vector BL.ByteString)
type StringMatrix = [[String]]

tab = fromIntegral $ ord '\t'
myDecodeOptions = defaultDecodeOptions {
    decDelimiter = tab
    }
myEncodeOptions = defaultEncodeOptions {
    encDelimiter =  tab
    }
decode' :: ByteString -> Either String ByteStringMatrix
decode' = decodeWith myDecodeOptions NoHeader
encode' = encodeWith myEncodeOptions 
printable = unpack . encode'

-- FIXME: toStrings may not be needed
-- EP: I convert from bytestrings to strings and Vector to [[String]]
--     String is just more faliar for me as of now than BL.ByteString 
toStrings :: Either String ByteStringMatrix -> StringMatrix
toStrings (Right v) = V.toList $ V.map (V.toList . (V.map unpack)) v 
toStrings (Left m) = error m -- a kind of a sink, getting out of Either ;))

main = do
    -- impure part
    -- read data from file 
    s <- BL.readFile "gdp.txt"
    -- parse CSV and coerce to string type     
    let k = toStrings . decode'  s
    
    -- pure part, manipulate tables
    let vs = T.toTuples k  
    -- end pure part

    -- impure again
    -- console message
    putStrLn $ printable vs
    -- write file to disk 
    BL.writeFile "gdp.csv" $ encode' vs