module Page.Home exposing (view, update, Model, Msg, init)

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Views.Page as Page
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Route exposing (Route)
import Material
import Material.Card as Card
import Material.Grid as Grid
import Material.Button as Button
import Material.Elevation as Elevation
import Material.Options as Options exposing (css, cs, attribute)
import DemoChart


-- MODEL --


type alias Mdl =
    Material.Model


type alias Model =
    { benchmarks : List String
    , mdl : Material.Model
    }


init : Task PageLoadError Model
init =
    let
        loadSources =
            Task.succeed [ "" ]

        mdl =
            Task.succeed Material.model

        handleLoadError _ =
            pageLoadError Page.Home "Homepage is currently unavailable"
    in
        Task.map2 Model loadSources mdl
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12 ]
            [ Card.view [ css "width" "100%", css "height" "260px", Elevation.e2 ]
                [ Card.text []
                    [ div [ class "demo-graph" ] [ DemoChart.renderLineChart ]
                    ]
                ]
            ]
        , Grid.cell [ Grid.size Grid.All 4 ]
            [ Card.view [ Elevation.e2 ]
                [ Card.title [] [ Card.head [] [ text "P1B1" ] ]
                , Card.text []
                    [ text "Autoencoder Compressed Representation for Gene Expression"
                    ]
                , Card.actions [ Card.border ]
                    [ Button.render Mdl
                        [ 1, 0 ]
                        model.mdl
                        [ Button.ripple
                        , Button.accent
                        , Button.link "#benchmark/P1B1"

                        -- , Options.attribute <| Route.href (Route.Benchmark "P1B1")
                        ]
                        [ text "read more" ]
                    ]
                ]
            ]
        , Grid.cell [ Grid.size Grid.All 4 ]
            [ Card.view [ Elevation.e2 ]
                [ Card.title [] [ Card.head [] [ text "P1B2" ] ]
                , Card.text []
                    [ text "Sparse Classifier Disease Type Prediction from Somatic SNPs"
                    ]
                , Card.actions [ Card.border ]
                    [ Button.render Mdl
                        [ 2, 0 ]
                        model.mdl
                        [ Button.ripple, Button.accent ]
                        [ text "read more" ]
                    ]
                ]
            ]
        , Grid.cell [ Grid.size Grid.All 4 ]
            [ Card.view [ Elevation.e2 ]
                [ Card.title [] [ Card.head [] [ text "P1B3" ] ]
                , Card.text []
                    [ text "MLP Regression Drug Response Prediction"
                    ]
                , Card.actions [ Card.border ]
                    [ Button.render Mdl
                        [ 3, 0 ]
                        model.mdl
                        [ Button.ripple, Button.accent ]
                        [ text "read more" ]
                    ]
                ]
            ]
        ]



-- UPDATE --


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
