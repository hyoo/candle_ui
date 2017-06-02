module Request.Benchmark exposing (..)

import Http
import Data.Benchmark as Benchmark exposing (benchmarkIdToString, Benchmark)
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
