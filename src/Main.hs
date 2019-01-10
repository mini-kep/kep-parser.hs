module Main where

import Convert
import Table

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

toMatrix :: BL.ByteString -> Either String ByteStringMatrix----
toMatrix bytestring = 
    decodeWith myDecodeOptions NoHeader bytestring -- :: Either String ByteMatrix 

encode' = encodeWith myEncodeOptions

-- Bottleneck: I convert from bytestrings to strings and Vector to []
toStrings :: Either String ByteStringMatrix -> [[String]]
toStrings (Right v) = V.toList $ V.map (V.toList . (V.map unpack)) v 
toStrings (Left m) = error m

main = do 
    s <- BL.readFile "gdp.txt"
    -- action with data
    let k = (toStrings . toMatrix) s
    -- print k
    let vs = (concatMap getValues . makeTables) k  
    -- print vs
    -- end action 
    BL.writeFile "gdp.csv" $ encode' vs