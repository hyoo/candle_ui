module Data.Benchmark exposing (Benchmark, BenchmarkId, decoder, benchmarkIdDecoder, benchmarkIdParser, benchmarkIdToString)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)
import UrlParser


type alias Benchmark =
    { benchmark_id : BenchmarkId
    , benchmark_title : String
    , overview : String
    , relavance : String
    , expected_outcome : String
    , data_description : List String
    , network_description : List String
    , expected_outcomes : List String
    , evaluation_metrics : List String
    , author : Maybe String
    , source_code : Maybe String
    }



-- SERIALIZATION --


decoder : Decoder Benchmark
decoder =
    decode Benchmark
        |> required "benchmark_id" benchmarkIdDecoder
        |> required "benchmark_title" Decode.string
        |> required "overview" Decode.string
        |> required "relavance" Decode.string
        |> required "expected_outcome" Decode.string
        |> required "data_description" (Decode.list Decode.string)
        |> required "network_description" (Decode.list Decode.string)
        |> required "expected_outcomes" (Decode.list Decode.string)
        |> required "evaluation_metrics" (Decode.list Decode.string)
        |> optional "author" (Decode.map Just Decode.string) Nothing
        |> optional "source_code" (Decode.map Just Decode.string) Nothing


type BenchmarkId
    = BenchmarkId String


benchmarkIdParser : UrlParser.Parser (BenchmarkId -> a) a
benchmarkIdParser =
    UrlParser.custom "BENCHMARK_ID" (Ok << BenchmarkId)


benchmarkIdToString : BenchmarkId -> String
benchmarkIdToString (BenchmarkId benchmarkId) =
    benchmarkId


benchmarkIdDecoder : Decoder BenchmarkId
benchmarkIdDecoder =
    Decode.map BenchmarkId Decode.string
