module Data.Experiment exposing (Experiment, ExperimentId, decoder, experimentIdParser, experimentIdToString)

import Data.Benchmark exposing (BenchmarkId, benchmarkIdDecoder)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)
import UrlParser


type alias Experiment =
    { benchmark_id : BenchmarkId

    -- dataset_id: DatasetId
    , experiment_id : ExperimentId
    , experiment_title : String
    , description : Maybe String
    , optimization_package_name: Maybe String
    , optimization_package_version: Maybe String
    , objective_function : Maybe String
    , search_space : Maybe (List String)
    , search_strategy : Maybe String
    , max_runs : Maybe Int
    , status : String
    , start_time : Maybe String -- Date?
    , end_time : Maybe String -- Date?
    , system_description: Maybe (List String)
    }



-- SERIALIZATION --


decoder : Decoder Experiment
decoder =
    decode Experiment
        |> required "benchmark_id" benchmarkIdDecoder
        |> required "experiment_id" experimentIdDecoder
        |> required "experiment_title" Decode.string
        |> optional "description" (Decode.map Just Decode.string) Nothing
        |> optional "optimization_package_name" (Decode.map Just Decode.string) Nothing
        |> optional "optimization_package_name_version" (Decode.map Just Decode.string) Nothing
        |> optional "objective_function" (Decode.map Just Decode.string) Nothing
        |> optional "search_space" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "search_strategy" (Decode.map Just Decode.string) Nothing
        |> optional "max_runs" (Decode.map Just Decode.int) Nothing
        |> required "status" Decode.string
        |> optional "start_time" (Decode.map Just Decode.string) Nothing
        |> optional "end_time" (Decode.map Just Decode.string) Nothing
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