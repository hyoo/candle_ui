module Request.Benchmark exposing (..)

import Http
import Data.Benchmark as Benchmark exposing (benchmarkIdToString, Benchmark)
import HttpBuilder exposing (withExpect, withQueryParams, RequestBuilder, withBody)
import Request.Helpers exposing (apiUrl)
import Json.Decode as Decode


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


list : ListConfig -> Http.Request (List Benchmark)
list config =
    [ ( "limit", Just (toString config.limit) )
    , ( "offset", Just (toString config.offset) )
    ]
        |> List.filterMap maybeVal
        |> buildFromQueryParams "/articles"
        |> HttpBuilder.toRequest



-- HELPERS --


maybeVal : ( a, Maybe b ) -> Maybe ( a, b )
maybeVal ( key, value ) =
    case value of
        Nothing ->
            Nothing

        Just val ->
            Just ( key, val )


buildFromQueryParams : String -> List ( String, String ) -> RequestBuilder (List Benchmark)
buildFromQueryParams url queryParams =
    let
        expect =
            Decode.list Benchmark.decoder
    in
        url
            |> apiUrl
            |> HttpBuilder.get
            |> withExpect (Http.expectJson expect)
            |> withQueryParams queryParams
