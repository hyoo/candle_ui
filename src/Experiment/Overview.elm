module Experiment.Overview exposing (..)

import Html exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs)
import Material.Elevation as Elevation
import Experiment.Filter
import Experiment.List
import DemoChart


view : Model -> Html Msg
view model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12 ]
            [ Card.view [ css "width" "100%", css "margin" "0 10px 10px 0", Elevation.e2 ]
                [ Card.title [] [ text "P1B1 > Experiment Test 4" ]
                , Card.text []
                    [ Options.div [ cs "demo-graph" ]
                        [ DemoChart.renderLineChart
                        ]
                    , Options.div [ cs "demo-chart" ]
                        [ DemoChart.renderPieChart
                        ]
                    ]
                ]
            , Card.view [ css "width" "100%" ]
                [ Card.text [ css "padding" "0", css "width" "100%" ]
                    [ Experiment.Filter.view model
                    , Experiment.List.view model
                    ]
                ]
            ]
        ]

