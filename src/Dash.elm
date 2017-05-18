module Dash exposing (..)

import DemoChart
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Grid as Grid
import Material.Options as Options exposing (css, cs)
import Models exposing (..)
import Msgs exposing (..)
import Routing exposing (benchmarkPath)


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
                        [ Button.ripple, Button.accent,
                          Options.onClick (Msgs.ChangeLocation (benchmarkPath "P1B1"))
                        ]
                        [ text "read more" ]
                    ]
                ]
            ]
        , Grid.cell [ Grid.size Grid.All 4 ]
            [Card.view [ Elevation.e2 ]
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
            [Card.view [ Elevation.e2 ]
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
