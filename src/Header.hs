module Header (name, unit, label) where

import Data.List (intercalate)

import Convert
import Label    

-- ERROR:
--    Variable not in scope: headers :: Table -> [[[Char]]]
--     |
--  10 | titles t = map (intercalate " ") (headers t)
titles :: Table -> [String]
titles t = map (intercalate " ") (headers t)

title :: Table -> String
title t = intercalate " " (titles t)

name :: Table -> Maybe String
name t = Label.getName $ title t

unit :: Table -> Maybe String
unit t = Label.getUnit $ title t

-- isDefined t = (name t /= Nothing) && (unit t /= Nothing)

label (Just name) (Just unit) = name ++ "_" ++ unit
label _ _ = "UNKNOWN"
