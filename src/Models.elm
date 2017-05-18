module Models exposing (..)


import Material

type alias Model =
    { mdl : Material.Model
    , route : Route
    }

type alias BenchmarkId =
    String

type alias ExperimentId =
    String

type Route
    = BenchmarksRoute
    | BenchmarkRoute BenchmarkId
    | ExperimentRoute ExperimentId
    | NotFoundRoute

initModel : Route -> Model
initModel route =
    { mdl = Material.model
    , route = route
    }
