module Table.Header (getLabel) where

import Data.List (intercalate)
import Table.Make (Table(..))
import qualified Table.Label as Label    

headerLines :: Table -> [String]
headerLines t = map (intercalate " ") (headers t)

title :: Table -> String
title t = intercalate " " (headerLines t)

name :: Table -> Maybe String
name t = Label.getName $ title t

unit :: Table -> Maybe String
unit t = Label.getUnit $ title t

isJust          :: Maybe a -> Bool
isJust (Just _) = True
isJust _        = False

--isDefined :: Table -> Bool
--isDefined t = isJust (name t) && isJust (unit t)

getLabel :: Table -> String
getLabel t = Label.compose (name t) (unit t)
