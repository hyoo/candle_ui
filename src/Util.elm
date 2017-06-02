module Util exposing (formatDate, formatDateTime)

import Date exposing (Date)
import Date.Format


formatDate : Maybe Date -> String
formatDate date =
    case date of
        Nothing ->
            ""

        Just date ->
            Date.Format.format "%Y.%m.%d" date


formatDateTime : Maybe Date -> String
formatDateTime date =
    case date of
        Nothing ->
            ""

        Just date ->
            Date.Format.format "%Y.%m.%d %H:%M:%S" date
