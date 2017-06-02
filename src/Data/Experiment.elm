module Data.Experiment exposing (Experiment, ExperimentId)

import Data.Benchmark exposing (BenchmarkId, benchmarkIdDecoder)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)


type alias Experiment =
    { benchmark_id : BenchmarkId

    -- dataset_id: DatasetId
    , experiment_id : ExperimentId
    , experiment_title : String
    , description : Maybe String

    -- , optimization_package_name: Maybe String
    -- , optimization_package_version: Maybe String
    , objective_function : Maybe String

    -- , search_space
    -- , search_strategy
    -- , max_runs : Int
    , status : String

    -- , start_time
    -- , end_time
    -- , system_description
    }



-- SERIALIZATION --


decoder : Decoder Experiment
decoder =
    decode Experiment
        |> required "benchmark_id" benchmarkIdDecoder
        |> required "experiment_id" experimentIdDecoder
        |> required "experiment_title" Decode.string
        |> required "description" (Decode.nullable Decode.string)
        |> required "objective_function" (Decode.nullable Decode.string)
        |> required "status" Decode.string



type ExperimentId
    = ExperimentId String


experimentIdDecoder : Decoder ExperimentId
experimentIdDecoder =
    Decode.map ExperimentId Decode.string
