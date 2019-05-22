-- https://twitter.com/Anka213/status/1123746090761768962

-- This is a complete implementation of a parser combinator in basically two lines of #Haskell. 
-- Example:
-- parse parens "(()(()()))"
-- Just (T [T [],T [T [],T []]],"")

import Control.Monad.State
import Control.Applicative
import Data.List

data T = T [T] deriving Show
type Parser = StateT String Maybe

ch :: Char -> Parser Char
ch c = mfilter (== c) $ StateT uncons

parens :: Parser T
parens = T <$ ch '(' <*> many parens <* ch ')'

-- parse :: Parser a -> String -> Maybe (a, String)
parse = runStateT