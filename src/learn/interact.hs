import Data.Char
import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V
-- from cassava
import Data.Csv

type ByteMatrix = V.Vector (V.Vector BL.ByteString)

interact' f = do 
    s <- getContents
    putStr (f s)

-- main = interact' id 

-- main = do
--     [f,g] <- getArgs
--     s     <- readFile f
--     writeFile g s

action s = s ++ "\n******************"

main = do
    s <- readFile "gdp.csv"
    print s
    let x = s ++ "\n******************"
    writeFile "gdp2.csv" x

-- myOptions = defaultDecodeOptions {
--     decDelimiter = fromIntegral (ord '\t')
--   }

-- -- parse long bytestring into matrix of strings
-- toMatrix :: BL.ByteString -> Either String ByteMatrix
-- toMatrix bytestring = 
--     decodeWith myOptions NoHeader bytestring 

-- -- work inside Either monad
-- useRight (Right x) = show x  
-- useRight (Left x) = error x  

-- main :: IO ()
-- main = do 
--     csvData <- BL.readFile "gdp.csv"
--     let m = toMatrix csvData
--     putStrLn $ useRight m