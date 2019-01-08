module Csv (toMatrix) where 

import Data.Char
import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V

-- cassava
import Data.Csv

type ByteMatrix = V.Vector (V.Vector BL.ByteString)

myOptions = defaultDecodeOptions {
    decDelimiter = fromIntegral (ord '\t')
    }

-- parse long bytestring into matrix of strings
toMatrix :: BL.ByteString -> Either String ByteMatrix
toMatrix bytestring = 
    decodeWith myOptions NoHeader bytestring -- :: Either String ByteMatrix 