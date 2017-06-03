module Route exposing (Route(..), href, routeToString, modifyUrl, fromLocation)

import UrlParser as Url exposing (parseHash, s, (</>), string, oneOf, Parser)
import Navigation exposing (Location)
import Html exposing (Attribute)
import Html.Attributes as Attr
import Data.Benchmark as Benchmark
import Data.Experiment as Experiment


-- ROUTING --


type Route
    = Home
    | Benchmark Benchmark.BenchmarkId
    | Experiment Experiment.ExperimentId


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Benchmark (s "benchmark" </> Benchmark.benchmarkIdParser)
        , Url.map Experiment (s "experiment" </> Experiment.experimentIdParser)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Benchmark id ->
                    [ "benchmark", Benchmark.benchmarkIdToString id ]

                Experiment id ->
                    [ "experiment", Experiment.experimentIdToString id ]
    in
        "#/" ++ (String.join "/" pieces)


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location
