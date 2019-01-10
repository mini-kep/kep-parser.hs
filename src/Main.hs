module Main where

import qualified Table.Table as T
import Table.Row (tup)

import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V
import Data.ByteString.Lazy.Char8 (pack, unpack) 
import Data.Char (ord)
import Data.Csv 

tab = fromIntegral (ord '\t')
myDecodeOptions = defaultDecodeOptions {
    decDelimiter = tab
    }
myEncodeOptions = defaultEncodeOptions {
    encDelimiter =  tab
    }

type ByteStringMatrix = V.Vector (V.Vector BL.ByteString)

toMatrix :: BL.ByteString -> Either String ByteStringMatrix
toMatrix bytestring = 
    decodeWith myDecodeOptions NoHeader bytestring -- :: Either String ByteMatrix 

--  Instead may use  
--  http://hackage.haskell.org/package/cassava-0.5.1.0/docs/Data-Csv.html#g:4

encode' x = encodeWith myEncodeOptions $ map tup x

-- Bottleneck: I convert from bytestrings to strings and Vector to []
toStrings :: Either String ByteStringMatrix -> [[String]]
toStrings (Right v) = V.toList $ V.map (V.toList . (V.map unpack)) v 
toStrings (Left m) = error m

main = do
    -- read data from file 
    s <- BL.readFile "gdp.txt"
    -- pure functions action part
    -- parse CSV and coerce to string type     
    let k = (toStrings . toMatrix) s
    -- manipulate tables
    let vs = (concatMap T.getValues) . T.makeTables $ k  
    print vs
    -- write file 
    BL.writeFile "gdp.csv" $ encode' vs