module Request.Experiment exposing (..)

import Http
import Data.Experiment as Experiment exposing (experimentIdToString, Experiment)
import Data.Experiment.Feed as Feed exposing (Feed)
import Data.Benchmark exposing (BenchmarkId, benchmarkIdToString, benchmarkIdParser)
import HttpBuilder exposing (withExpect, withQueryParams, RequestBuilder, withBody)
import Request.Helpers exposing (apiUrl)


-- SINGLE --


get : Experiment.ExperimentId -> Http.Request Experiment
get experimentId =
    let
        expect =
            Experiment.decoder
                |> Http.expectJson
    in
        apiUrl ("experiment/" ++ experimentIdToString experimentId)
            |> HttpBuilder.get
            |> HttpBuilder.withExpect expect
            |> HttpBuilder.toRequest



-- LIST --


type alias ListConfig =
    { benchmark_id : Maybe BenchmarkId
    , limit : Int
    , offset : Int
    }


defaultListConfig : ListConfig
defaultListConfig =
    { benchmark_id = Nothing
    , limit = 20
    , offset = 0
    }


buildQuery : ListConfig -> Maybe String
buildQuery config =
    case config.benchmark_id of
        Just id ->
            Just ("benchmark_id:" ++ (benchmarkIdToString id))

        Nothing ->
            Nothing


list : ListConfig -> Http.Request Feed
list config =
    [ ( "q", (buildQuery config) )
    , ( "rows", Just (toString config.limit) )
    , ( "start", Just (toString config.offset) )
    ]
        |> List.filterMap maybeVal
        |> buildFromQueryParams "experiment/"
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
