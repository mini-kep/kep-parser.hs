module Header (name, unit, label) where

import Data.List (intercalate)

import Types
import Label    

spaces = intercalate " "

titles :: Table -> [String]
titles t = map spaces (headerRows t)

title :: Table -> String
title t = spaces (titles t)

name :: Table -> Maybe String
name t = Label.getName $ title t

unit :: Table -> Maybe String
unit t = Label.getUnit $ title t

-- isDefined t = (name t /= Nothing) && (unit t /= Nothing)

label (Just name) (Just unit) = name ++ "_" ++ unit

