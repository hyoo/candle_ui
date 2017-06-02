module Util exposing (..)


import Date exposing (Date)
import Date.Format

formateDate : Maybe Date -> String
formateDate date =
    case date of
        Nothing ->
            ""
        Just date ->
            Date.Format.format "%Y.%m.%d %H:%M:%S" date