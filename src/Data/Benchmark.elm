module Data.Benchmark exposing (Benchmark, BenchmarkId, decoder, benchmarkIdDecoder, benchmarkIdParser, benchmarkIdToString)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)
import UrlParser


type alias Benchmark =
    { benchmark_id : BenchmarkId
    , benchmark_title : String
    , overview : Maybe String
    , relavance : Maybe String
    , expected_outcome : Maybe String
    , data_description : Maybe (List String)
    , network_description : Maybe (List String)
    , expected_outcomes : Maybe (List String)
    , evaluation_metrics : Maybe (List String)
    , author : Maybe String
    , source_code : Maybe String
    }



-- SERIALIZATION --


decoder : Decoder Benchmark
decoder =
    decode Benchmark
        |> required "benchmark_id" benchmarkIdDecoder
        |> required "benchmark_title" Decode.string
        |> optional "overview" (Decode.map Just Decode.string) Nothing
        |> optional "relavance" (Decode.map Just Decode.string) Nothing
        |> optional "expected_outcome" (Decode.map Just Decode.string) Nothing
        |> optional "data_description" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "network_description" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "expected_outcomes" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "evaluation_metrics" (Decode.map Just (Decode.list Decode.string)) Nothing
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
