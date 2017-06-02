module Data.Run exposing (Run, RunId, decoder, runIdParser, runIdToString)

import Data.Benchmark exposing (BenchmarkId, benchmarkIdDecoder)
import Data.Experiment exposing (ExperimentId, experimentIdDecoder)
import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional)
import Json.Decode.Extra
import UrlParser


type alias Run =
    { benchmark_id : BenchmarkId
    , dataset_id : Maybe String
    , experiment_id : ExperimentId
    , run_id : RunId
    , parameters : Maybe (List String)
    , start_time : Maybe Date
    , end_time : Maybe Date
    , runtime_hours : Maybe Float
    , status : Maybe String
    , run_progress : Maybe (List String)
    , training_accuracy : Maybe Float
    , training_loss : Maybe Float
    , validation_accuracy : Maybe Float
    , validation_loss : Maybe Float
    , model_checkpoint_file : Maybe String
    , model_description_file : Maybe String
    , model_weight_file : Maybe String
    , model_result_files : Maybe (List String)
    }



--- SERIALIZATION --


decoder : Decoder Run
decoder =
    decode Run
        |> required "benchmark_id" benchmarkIdDecoder
        |> optional "dataset_id" (Decode.map Just Decode.string) Nothing
        |> required "experiment_id" experimentIdDecoder
        |> required "run_id" runIdDecoder
        |> optional "parameters" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "start_time" (Decode.map Just Json.Decode.Extra.date) Nothing
        |> optional "end_time" (Decode.map Just Json.Decode.Extra.date) Nothing
        |> optional "runtime_hours" (Decode.map Just Decode.float) Nothing
        |> optional "status" (Decode.map Just Decode.string) Nothing
        |> optional "run_progress" (Decode.map Just (Decode.list Decode.string)) Nothing
        |> optional "training_accuracy" (Decode.map Just Decode.float) Nothing
        |> optional "training_loss" (Decode.map Just Decode.float) Nothing
        |> optional "validation_accuracy" (Decode.map Just Decode.float) Nothing
        |> optional "validation_loss" (Decode.map Just Decode.float) Nothing
        |> optional "model_checkpoint_file" (Decode.map Just Decode.string) Nothing
        |> optional "model_description_file" (Decode.map Just Decode.string) Nothing
        |> optional "model_weight_file" (Decode.map Just Decode.string) Nothing
        |> optional "model_result_files" (Decode.map Just (Decode.list Decode.string)) Nothing


type RunId
    = RunId String


runIdParser : UrlParser.Parser (RunId -> a) a
runIdParser =
    UrlParser.custom "RUN_ID" (Ok << RunId)


runIdToString : RunId -> String
runIdToString (RunId runId) =
    runId


runIdDecoder : Decoder RunId
runIdDecoder =
    Decode.map RunId Decode.string
