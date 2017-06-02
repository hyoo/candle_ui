module Data.Benchmark.Feed exposing (Feed, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Data.Benchmark as Benchmark exposing (Benchmark)


type alias Feed =
    { benchmarks : List Benchmark
    , benchmarksCount : Int
    }



-- SERIALIZATION --


decoder : Decoder Feed
decoder =
    decode Feed
        |> required "docs" (Decode.list Benchmark.decoder)
        |> required "numFound" Decode.int
