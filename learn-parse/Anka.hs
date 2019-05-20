-- https://twitter.com/Anka213/status/1123746090761768962

-- This is a complete implementation of a parser combinator in basically two lines of #Haskell. 
-- #ParserCombinators
-- Example:

-- parse parens “(()(()()))”
-- T [T [], T [T [], T []]]

import Control.Monad.State
import Control.Applicative
import Data.List

data T = T [T]
type Parser = StateT String Maybe

ch :: Parser Char
ch c = mfilter (== c) $ StateT uncons

parens :: Parser T
parens = T <$ ch '(' <*> many parens <* ch ')'

-- parse :: Parser a -> String -> Maybe (a, String)
parse = runStateT

-- Anka.hs:21:16: error:
--     * Couldn't match expected type `Char -> StateT String Maybe b0'
--                   with actual type `StateT String Maybe Char'
--     * The function `ch' is applied to one argument,
--       but its type `StateT String Maybe Char' has none
--       In the second argument of `(<$)', namely `(ch '(')'
--       In the first argument of `(<*>)', namely `T <$ (ch '(')'
--    |
-- 21 | parens = T <$ (ch '(') <*> many parens <* (ch ')')
--    |                ^^^^^^

-- Anka.hs:21:44: error:
--     * Couldn't match expected type `Char -> StateT String Maybe b1'
--                   with actual type `StateT String Maybe Char'
--     * The function `ch' is applied to one argument,
--       but its type `StateT String Maybe Char' has none
--       In the second argument of `(<*)', namely `(ch ')')'
--       In the expression: T <$ (ch '(') <*> many parens <* (ch ')')
--    |
-- 21 | parens = T <$ (ch '(') <*> many parens <* (ch ')')
--    |                                            ^^^^^^
-- Failed, no modules loaded.