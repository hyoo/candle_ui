module Data.Run.Feed exposing (Feed, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Data.Run as Run exposing (Run)


type alias Feed =
    { runs : List Run
    , runsCount : Int
    }



-- SERIALIZATION --


decoder : Decoder Feed
decoder =
    decode Feed
        |> required "docs" (Decode.list Run.decoder)
        |> required "numFound" Decode.int
