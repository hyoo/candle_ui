module Experiment.List exposing (..) 


import Html exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Material.Table as Table
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Dialog as Dialog
-- import Routing exposing(experimentPath)

view : Model -> Html Msg
view model =
    renderTable model

renderTable : Model -> Html Msg
renderTable model =
    Table.table [ css "width" "100%" ]
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "Run ID" ]
                , Table.th [] [ text "Start Time" ]
                , Table.th [] [ text "End Time" ]
                , Table.th [] [ text "Runtime" ]
                , Table.th [] [ text "Status" ]
                , Table.th [] [ text "Training Accuracy" ]
                , Table.th [] [ text "Training Loss" ]
                , Table.th [] [ text "Action" ]
                ]
            ]
        , Table.tbody [] [ renderRow model ]
        ]


renderRow : Model -> Html Msg
renderRow model =
    Table.tr []
        [ Table.td [] [ text "p1b1_es1_exp1_0004.0203" ]
        , Table.td [] [ text "2017-5-17:16:32:10" ]
        , Table.td [] [ text "-" ]
        , Table.td [] [ text "01:23:45" ]
        , Table.td [] [ text "Running" ]
        , Table.td [] [ text "0.87" ]
        , Table.td [] [ text "0.00242" ]
        , Table.td [] [ Button.render Mdl [ 1 ] model.mdl 
            [ Button.ripple --, Options.onClick (Msgs.ChangeLocation (experimentPath "p1b1_es1_exp1_0004")) 
            , Dialog.openOn "click"
            ]
            [ text "detail" ] ]
        ]
