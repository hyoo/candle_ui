module Data.Experiment.Feed exposing (Feed, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Data.Experiment as Experiment exposing (Experiment)


type alias Feed =
    { experiments : List Experiment
    , experimentsCount : Int
    }



-- SERIALIZATION --


decoder : Decoder Feed
decoder =
    decode Feed
        |> required "docs" (Decode.list Experiment.decoder)
        |> required "numFound" Decode.int
