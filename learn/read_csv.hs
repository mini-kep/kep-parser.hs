-- Read CSV file, split it to tables, extract values from tables
-- "gdp.csv" -> [Table] -> [Value]


-- http://howistart.org/posts/haskell/1/
-- module Main where

    import Data.Char
    import qualified Data.ByteString.Lazy as BL
    import qualified Data.Vector as V
    -- from cassava
    import Data.Csv
    
    type ByteMatrix = V.Vector (V.Vector BL.ByteString)

    myOptions = defaultDecodeOptions {
        decDelimiter = fromIntegral (ord '\t')
      }

    -- parse long bytestring into matrix of strings
    toMatrix :: BL.ByteString -> Either String ByteMatrix
    toMatrix bytestring = 
        decodeWith myOptions NoHeader bytestring -- :: Either String ByteMatrix 

    main :: IO ()
    main = do 
        csvData <- BL.readFile "gdp.csv"
        let m = toMatrix csvData
        putStrLn $ useRight m

-- TODO: merge this to file        
