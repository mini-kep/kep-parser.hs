-- https://hackage.haskell.org/package/haste-compiler-0.5.5.1/src/libraries/haste-lib/src/Haste/Parsing.hs
-- https://github.com/valderman/haste-compiler/blob/master/libraries/haste-lib/src/Haste/Parsing.hs

-- QQQ: нашел как запускать для простейших случаев, но не нашел как в более сложном
-- runParser (char 'a') "a"
-- runParser (many (char 'a')) "aaa"
-- runParser (string "123") "123"

-- но если :
-- runParser (char 'a') "ab"
-- то результат Nothing

-- QQQ: не понятно как комбинировать парсеры, чтобы прочиталась вся строка
--      что-то типа someOf, anyOf
-- QQQ: банальный вопрос - зачем нам из строки строка?


{-# LANGUAGE FlexibleInstances #-}
-- | Home-grown parser, just because.
module Haste.Parsing (
    Parse, runParser, char, charP, string, oneOf, possibly, atLeast,
    whitespace, word, Haste.Parsing.words, int, double, positiveDouble,
    suchThat, quotedString, skip, rest, lookahead, anyChar
  ) where
import Control.Applicative
import Control.Monad
import Data.Char

newtype Parse a = Parse {unP :: (String -> Maybe (String, a))}

runParser :: Parse a -> String -> Maybe a
-- Q+:  (Parse p) достает функцию p :: (String -> Maybe (String, a))?
--      unP ps тоже по идее даст эту функцию?
--      c pattern matching понятнее!   
runParser (Parse p) s =
  case p s of
    Just ("", x) -> Just x -- Q: если строка закочилась, значит парсер отработал?
    _            -> Nothing

instance Monad Parse where
  return x = Parse $ \s -> Just (s, x)
  Parse m >>= f = Parse $ \s -> do
    (s', x) <- m s -- QQQ: почему здесь tuple, а не Maybe? m s же должна выдать Maybe (String, a)
    unP (f x) s'   -- Q: у f видимо тип a -> Parser a

instance Alternative Parse where
  empty = mzero
  (<|>) = mplus

instance MonadPlus Parse where
  mplus (Parse p1) (Parse p2) = Parse $ \s ->
    case p1 s of
      x@(Just _) -> x
      _          -> p2 s
  mzero = Parse $ const Nothing

instance Functor Parse where
  -- QQQ: два fmap взрывают мозг
  fmap f (Parse g) = Parse $ fmap (fmap f) . g

instance Applicative Parse where
  pure  = return
  (<*>) = ap

-- | Read one character. Fails if end of stream.
anyChar :: Parse Char
anyChar = Parse $ \s ->
  case s of
    (c:cs) -> Just (cs, c)
    _      -> Nothing

-- | Require a specific character.
char :: Char -> Parse Char
-- Q+: хоть тут все понятно!
char c = charP (== c)

-- | Parse a character that matches a given predicate.
charP :: (Char -> Bool) -> Parse Char
charP p = Parse $ \s ->
  case s of
    -- QQQ: эта палка | - это guard? смущает что на второй строке без палки
    (c:next) | p c -> Just (next, c)
    _              -> Nothing  

-- | Require a specific string.
string :: String -> Parse String
string str = Parse $ \s ->
  let len        = length str
      (s', next) = splitAt len s
  in if s' == str
       then Just (next, str)
       else Nothing

-- | Apply the first matching parser.
oneOf :: [Parse a] -> Parse a
oneOf = msum

-- | Invoke a parser with the possibility of failure.
possibly :: Parse a -> Parse (Maybe a)
possibly p = oneOf [Just <$> p, return Nothing]

-- | Invoke a parser at least n times.
atLeast :: Int -> Parse a -> Parse [a]
atLeast 0 p = do
  x <- possibly p
  case x of
    Just x' -> do
      xs <- atLeast 0 p
      return (x':xs)
    _ ->
      return []
atLeast n p = do
  x <- p
  xs <- atLeast (n-1) p
  return (x:xs)

-- | Parse zero or more characters of whitespace.
whitespace :: Parse String
whitespace = atLeast 0 $ charP isSpace

-- | Parse a non-empty word. A word is a string of at least one non-whitespace
--   character.
word :: Parse String
word = atLeast 1 $ charP (not . isSpace)

-- | Parse several words, separated by whitespace.
words :: Parse [String]
words = atLeast 0 $ word <* whitespace

-- | Parse an Int.
int :: Parse Int
int = oneOf [read <$> atLeast 1 (charP isDigit),
             char '-' >> (0-) . read <$> atLeast 1 (charP isDigit)]

-- | Parse a floating point number.
double :: Parse Double
double = oneOf [positiveDouble,
                char '-' >> (0-) <$> positiveDouble]

-- | Parse a non-negative floating point number.
positiveDouble :: Parse Double
positiveDouble = do
  first <- atLeast 1 $ charP isDigit
  msecond <- possibly $ char '.' *> atLeast 1 (charP isDigit)
  case msecond of
    Just second -> return $ read $ first ++ "." ++ second
    _           -> return $ read first

-- | Fail on unwanted input.
suchThat :: Parse a -> (a -> Bool) -> Parse a
suchThat p f = do {x <- p ; if f x then return x else mzero}

-- | A string quoted with the given quotation mark. Strings can contain escaped
--   quotation marks; escape characters are stripped from the returned string.
quotedString :: Char -> Parse String
quotedString q = char q *> strContents q <* char q

strContents :: Char -> Parse String
strContents c = do
  s <- atLeast 0 $ charP (\x -> x /= c && x /= '\\')
  c' <- lookahead anyChar
  if c == c'
    then do
      return s
    else do
      skip 1
      c'' <- anyChar
      s' <- strContents c
      return $ s ++ [c''] ++ s'

-- | Read the rest of the input.
rest :: Parse String
rest = Parse $ \s -> Just ("", s)

-- | Run a parser with the current parsing state, but don't consume any input.
lookahead :: Parse a -> Parse a
lookahead p = do
  s' <- Parse $ \s -> Just (s, s)
  x <- p
  Parse $ \_ -> Just (s', x)

-- | Skip n characters from the input.
skip :: Int -> Parse ()
skip n = Parse $ \s -> Just (drop n s, ())