module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (BenchmarkId, Route(..))
import UrlParser exposing(..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map BenchmarksRoute top
        , map BenchmarkRoute (s "benchmark" </> string)
        , map ExperimentRoute (s "experiment" </> string)
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route 
        Nothing ->
            NotFoundRoute

benchmarkPath : String -> String
benchmarkPath benchmarkId =
    "#benchmark/" ++ benchmarkId 

experimentPath : String -> String
experimentPath experimentId =
    "#experiment/" ++ experimentId