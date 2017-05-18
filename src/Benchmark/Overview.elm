module Benchmark.Overview exposing (..)

import Html exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs)
import Material.Elevation as Elevation
import Benchmark.Filter
import Benchmark.List

view : Model -> Html Msg
view model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12 ]
            [ Card.view [ css "width" "100%", css "margin" "0 10px 10px 0", Elevation.e2 ]
                [ Card.title [] [ text "P1B1: Autoencoder Compressed Representation for Gene Expression" ]
                , Card.text []
                    [ p [] [ text "Overview:Given a sample of gene expression data, build a sparse autoencoder that can compress the expression profile into a low-dimensional vector." ]
                    , p [] [ text "Relationship to core problem: Many molecular assays generate large numbers of features that can lead to time-consuming processing and over-fitting in learning tasks; hence, a core capability we intend to build is feature reduction." ]
                    , span [] [ text "...more" ]
                      {-
                         """
                         Expected outcome: Build an autoencoder that collapse high dimensional expression profiles into low dimensional vectors without much loss of information.

                         Benchmark Specs Requirements

                         Description of the Data

                         Data source: RNA-seq data from GDC
                         Input dimensions: 60,484 floats; log(1+x) transformed FPKM-UQ values
                         Output dimensions: Same as input
                         Latent representation dimension: 1000
                         Sample size: 4,000 (3000 training + 1000 test)
                         Notes on data balance and other issues: unlabeled data draw from a diverse set of cancer types
                         Expected Outcomes

                         Reconstructed expression profiles
                         Output range: float; same as log transformed input
                         Evaluation Metrics

                         Accuracy or loss function: mean squared error
                         Expected performance of a naïve method: landmark genes picked by linear regression
                         Description of the Network

                         Proposed network architecture: MLP with encoding layers, dropout layers, bottleneck layer, and decoding layers
                         Number of layers: At least three hidden layers including one encoding layer, one bottleneck layer, and one decoding layer
                         """
                         -
                      -}
                    ]
                ]
            , Card.view [ css "width" "100%" ]
                [ Card.text [ css "padding" "0", css "width" "100%"]
                    [ Benchmark.Filter.view model
                    , Benchmark.List.view model
                    ]
                ]
            ]
        ]
