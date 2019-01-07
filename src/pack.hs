import Data.ByteString.Char8 (pack)

s' = "GDP\n% change to year earlier\n2017\t100,6\t102,5\t102,2\t100,9\n2018\t101,3\t101,9\t101,5\t\n\nGDP, bln run (current price)\n2017\t20549,8\t22035,1\t23948,8\t25503,4\n2018\t22239,4\t24846,6\t27007,2\t\n\n"

main = print $ pack s'