module Benchmark.Overview exposing (..)

import Html exposing (..)
import Html.Attributes exposing (hidden)
import Models exposing (..)
import Msgs exposing (..)
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs)
import Material.Elevation as Elevation
import Material.Toggles as Toggles
import Benchmark.Filter
import Benchmark.List


view : Model -> Html Msg
view model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12 ]
            [ Card.view [ css "width" "100%", css "margin" "0 10px 10px 0", Elevation.e2 ]
                [ Card.title [] [ text "P1B1: Autoencoder Compressed Representation for Gene Expression" ]
                , Card.text []
                    [ p []
                        [ strong [] [ text "Overview: " ]
                        , text "Given a sample of gene expression data, build a sparse autoencoder that can compress the expression profile into a low-dimensional vector."
                        ]
                    , p []
                        [ strong [] [ text "Relationship to core problem: " ]
                        , text "Many molecular assays generate large numbers of features that can lead to time-consuming processing and over-fitting in learning tasks; hence, a core capability we intend to build is feature reduction."
                        ]
                    , p [ hidden (getToggleValue 0 model) ]
                        [ strong [] [ text "Expected outcome: " ]
                        , text "Build an autoencoder that collapse high dimensional expression profiles into low dimensional vectors without much loss of information."
                        ]
                    , p [ hidden (getToggleValue 0 model) ] [ h4 [] [ text "Benchmark Specs Requirements" ] ]
                    , p [ hidden (getToggleValue 0 model) ]
                        [ renderListItems "Description of the Data"
                            [ "Data source: RNA-seq data from GDC"
                            , "Input dimensions: 60,484 floats; log(1+x) transformed FPKM-UQ values"
                            , "Output dimensions: Same as input"
                            , "Latent representation dimension: 1000"
                            , "Sample size: 4,000 (3000 training + 1000 test)"
                            , "Notes on data balance and other issues: unlabeled data draw from a diverse set of cancer types"
                            ]
                        ]
                    , p [ hidden (getToggleValue 0 model) ]
                        [ renderListItems "Expected Outcomes"
                            [ "Reconstructed expression profiles"
                            , "Output range: float; same as log transformed input"
                            ]
                        ]
                    , p [ hidden (getToggleValue 0 model) ]
                        [ renderListItems "Evaluation Metrics"
                            [ "Accuracy or loss function: mean squared error"
                            , "Expected performance of a naïve method: landmark genes picked by linear regression"
                            ]
                        ]
                    , p [ hidden (getToggleValue 0 model) ]
                        [ renderListItems "Description of the Network"
                            [ "Proposed network architecture: MLP with encoding layers, dropout layers, bottleneck layer, and decoding layers"
                            , "Number of layers: At least three hidden layers including one encoding layer, one bottleneck layer, and one decoding layer"
                            ]
                        ]
                    , Toggles.switch Mdl
                        [ 0 ]
                        model.mdl
                        [ Options.onToggle (Msgs.Switch 0)
                        , Toggles.ripple
                        , Toggles.value (not (getToggleValue 0 model))
                        ]
                        [ text "see more" ]
                    ]
                ]
            , Card.view [ css "width" "100%" ]
                [ Card.text [ css "padding" "0", css "width" "100%" ]
                    [ Benchmark.Filter.view model
                    , Benchmark.List.view model
                    ]
                ]
            ]
        ]


renderListItems : String -> List String -> Html Msg
renderListItems title items =
    let
        list =
            List.map (\item -> li [] [ text item ]) items
    in
        h5 []
            [ text title
            , ul [] list
            ]
