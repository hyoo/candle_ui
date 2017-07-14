module Data.Experiment exposing (Experiment, ExperimentId, decoder, experimentIdDecoder, experimentIdParser, experimentIdToString)

import Data.Benchmark exposing (BenchmarkId, benchmarkIdDecoder)
import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)
import Json.Decode.Extra
import UrlParser


type alias Experiment =
    { benchmark_id : BenchmarkId
    , dataset_id : Maybe String
    , experiment_id : ExperimentId
    , experiment_title : Maybe String
    , description : Maybe String
    , optimization_package_name : Maybe String
    , optimization_package_version : Maybe String
    , objective_function : Maybe String
    , search_space : Maybe (List String)
    , search_strategy : Maybe String
    , max_runs : Maybe Int
    , status : String
    , start_time : Maybe Date
    , end_time : Maybe Date
    , system_description : Maybe (List String)
    }



-- SERIALIZATION --


decoder : Decoder Experiment
decoder =
    decode Experiment
        |> required "benchmark_id" benchmarkIdDecoder
        |> optional "dataset_id" (Decode.map Just Decode.string) Nothing
        |> required "experiment_id" experimentIdDecoder
        |> optional "experiment_title" (Decode.map Just Decode.string) Nothing
        |> optional "description" (Decode.map Just Decode.string) Nothing
        |> optional "optimization_package_name" (Decode.map Just Decode.string) Nothing
        |> optional "optimization_package_name_version" (Decode.map Just Decode.string) Nothing
        |> optional "objective_function" (Decode.map Just Decode.string) Nothing
        |> optional "search_space" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "search_strategy" (Decode.map Just Decode.string) Nothing
        |> optional "max_runs" (Decode.map Just Decode.int) Nothing
        |> required "status" Decode.string
        |> optional "start_time" (Decode.map Just Json.Decode.Extra.date) Nothing
        |> optional "end_time" (Decode.map Just Json.Decode.Extra.date) Nothing
        |> optional "system_description" (Decode.map Just (Decode.list Decode.string)) Nothing


type ExperimentId
    = ExperimentId String


experimentIdParser : UrlParser.Parser (ExperimentId -> a) a
experimentIdParser =
    UrlParser.custom "EXPERIMENT_ID" (Ok << ExperimentId)


experimentIdToString : ExperimentId -> String
experimentIdToString (ExperimentId experimentId) =
    experimentId


experimentIdDecoder : Decoder ExperimentId
experimentIdDecoder =
    Decode.map ExperimentId Decode.string
