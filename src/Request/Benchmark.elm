module Request.Benchmark exposing (..)

import Http
import Data.Benchmark as Benchmark exposing (benchmarkIdToString, Benchmark)
import Data.Benchmark.Feed as Feed exposing (Feed)
import HttpBuilder exposing (withExpect, withQueryParams, RequestBuilder, withBody)
import Request.Helpers exposing (apiUrl)


-- SINGLE --


get : Benchmark.BenchmarkId -> Http.Request Benchmark
get benchmarkId =
    let
        expect =
            Benchmark.decoder
                |> Http.expectJson
    in
        apiUrl ("benchmark/" ++ Benchmark.benchmarkIdToString benchmarkId)
            |> HttpBuilder.get
            |> HttpBuilder.withExpect expect
            |> HttpBuilder.toRequest



-- LIST --


type alias ListConfig =
    { limit : Int
    , offset : Int
    }


defaultListConfig : ListConfig
defaultListConfig =
    { limit = 20
    , offset = 0
    }


list : ListConfig -> Http.Request Feed
list config =
    [ ( "q", Just "*:*" )
    , ( "rows", Just (toString config.limit) )
    , ( "start", Just (toString config.offset) )
    ]
        |> List.filterMap maybeVal
        |> buildFromQueryParams "benchmark/"
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
