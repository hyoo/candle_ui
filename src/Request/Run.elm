module Request.Run exposing (..)

import Http
import Data.Benchmark as Benchmark exposing (BenchmarkId, benchmarkIdToString, benchmarkIdParser, Benchmark)
import Data.Experiment as Experiment exposing (ExperimentId, experimentIdToString, Experiment)
import Data.Run as Run exposing (RunId, runIdToString, runIdParser, Run)
import Data.Run.Feed as Feed exposing (Feed)
import HttpBuilder exposing (withExpect, withQueryParams, RequestBuilder, withBody)
import Request.Helpers exposing (apiUrl)


-- SINGLE --


get : Run.RunId -> Http.Request Run
get runId =
    let
        expect =
            Run.decoder
                |> Http.expectJson
    in
        apiUrl ("run/" ++ runIdToString runId)
            |> HttpBuilder.get
            |> HttpBuilder.withExpect expect
            |> HttpBuilder.toRequest



-- LIST --


type alias ListConfig =
    { benchmark_id : Maybe BenchmarkId
    , experiment_id : Maybe ExperimentId
    , limit : Int
    , offset : Int
    }


defaultListConfig : ListConfig
defaultListConfig =
    { benchmark_id = Nothing
    , experiment_id = Nothing
    , limit = 20
    , offset = 0
    }


buildQuery : ListConfig -> Maybe String
buildQuery config =
    case config.experiment_id of
        Just id ->
            Just ("experiment_id:" ++ (experimentIdToString id))

        Nothing ->
            Nothing


list : ListConfig -> Http.Request Feed
list config =
    [ ( "q", (buildQuery config) )
    , ( "rows", Just (toString config.limit) )
    , ( "start", Just (toString config.offset) )
    ]
        |> List.filterMap maybeVal
        |> buildFromQueryParams "run/"
        |> HttpBuilder.toRequest



-- HELPERS --


maybeVal : ( a, Maybe b ) -> Maybe ( a, b )
maybeVal ( key, value ) =
    case value of
        Nothing ->
            Nothing

        Just val ->
            Just ( key, val )


buildFromQueryParams : String -> List ( String, String ) -> RequestBuilder Feed
buildFromQueryParams url queryParams =
    url
        |> apiUrl
        |> HttpBuilder.get
        |> withExpect (Http.expectJson Feed.decoder)
        |> withQueryParams queryParams
