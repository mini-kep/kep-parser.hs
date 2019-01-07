module File where 
  
import Data.Char (ord)
import Data.Csv (encodeWith, encDelimiter, defaultEncodeOptions)
    
myOptions' = defaultEncodeOptions {
      encDelimiter = fromIntegral (ord '\t')
    }

encode' = encodeWith myOptions'
