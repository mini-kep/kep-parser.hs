-- type ParseOperation = String -> [(a,String)] 

newtype StateT s m a = StateT { runStateT :: s -> m (a,s) }

newtype Parser a = Parser { unParser :: StateT String Maybe a }
runParser = runStateT . unParser

{-

The real beauty (or magic, as some would say) of this monad comes from the bind function. Let’s take a look at its definition:

(>>=) :: Monad n => StateT s n a -> (a -> StateT s n a) -> StateT s n a
m >>= k  = StateT $ \ s -> do
    ~(a, s') <- runStateT m s
    runStateT (k a) s'

Time to break it down. m is a state transformer. k is a function that takes a result of type a, and returns a state transformer. The final state transformer, when run with an initial state, does the following:

    Gets the result and state of running the computation in m with the initial state s
    Passes the result of (1) to the function k, returning a different state transformer
    Runs the computation created in (2) using the state returned in (1)
    Wraps the result

-}


-- runParser :: Parser a -> String -> Maybe a
-- runParser p s =
--   case parse p s of
--     (Just res, []) -> Just res
--     otherwise      -> Nothing

-- -- bind :: Parser a -> (a -> Parser b) -> Parser b
-- bind p f = Parser (\s -> case parse p s of
--     (Just res, out) -> parse (f res) out
--     []        -> []
--     [(v,out)] -> parse (f v) out
--     )

-- --itemF :: String -> [(a,String)]
-- itemF []     = []
-- itemF (c:cs) = [(c,cs)]

-- item :: Parser Char
-- item = Parser $ itemF 

-- -- *Main> itemF "abc"
-- -- [('a',"bc")]

-- -- parse item "abc"
-- -- [('a',"bc")]

-- -- A bind operation for our parser type will take one parse operation and 
-- -- compose it over the result of second parse function. Since the parser 
-- -- operation yields a list of tuples, composing a second parser function 
-- -- simply maps itself over the resulting list and concat's the resulting 
-- -- nested list of lists into a single flat list in the usual list monad fashion. 


-- -- bind p f = Parser $ \s -> concatMap (\(a, s') -> parse (f a) s') $ (parse p) s



