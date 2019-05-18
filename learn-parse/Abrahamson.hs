-- https://stackoverflow.com/questions/20660782/writing-a-parser-from-scratch-in-haskell
-- Abrahamson




type Error = String
newtype Parser a = P { unP :: String -> (String, Either Error a) }


instance Functor Parser where
  fmap f (P g) = P $ \stream -> case g stream of
    (res, Left err) -> (res, Left err)
    (res, Right a ) -> (res, Right (f a))

instance Applicative Parser where
  pure a = P (\stream -> (stream, Right a))
  P ff <*> P xx = P $ \inp -> case ff inp of   -- produce an f
    (stream1, Left err) -> (stream1, Left err)
    (stream1, Right f ) -> case xx stream1 of          -- produce an x
      (stream2, Left err) -> (stream2, Left err)
      (stream2, Right x ) -> (stream2, Right (f x))    -- return (f x)

