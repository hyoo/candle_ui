module Models exposing (..)

import Material
import Array


type alias Model =
    { mdl : Material.Model
    , route : Route
    , toggles : Array.Array Bool
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
    , toggles = Array.fromList [ True, False ]
    }


getToggleValue : Int -> Model -> Bool
getToggleValue k model =
    Array.get k model.toggles |> Maybe.withDefault False
