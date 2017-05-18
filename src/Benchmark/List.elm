module Benchmark.List exposing (..)

import Html exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Material.Table as Table
import Material.Button as Button
import Material.Options as Options exposing (css)
import Routing exposing(experimentPath)

view : Model -> Html Msg
view model =
    renderTable model



-- renderTable : Model -> List Patient -> Html Msg
-- renderTable model patients =


renderTable : Model -> Html Msg
renderTable model =
    Table.table [ css "width" "100%" ]
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ text "DataSet ID" ]
                , Table.th [] [ text "Experiment ID" ]
                , Table.th [] [ text "Title" ]
                , Table.th [] [ text "Status" ]
                , Table.th [] [ text "Start Time" ]
                , Table.th [] [ text "End Time" ]
                , Table.th [] [ text "Action" ]
                ]
            ]
          -- , Table.tbody [] (List.map (renderRow model) patients)
        , Table.tbody [] [ renderRow model ]
        ]



-- patientRow : Model -> Patient -> Html Msg
-- patientRow model patient =
--     Table.tr []
--         [ Table.td [] [ text patient.vendor_sample_number ]
--         , Table.td [] [ text patient.institution ]
--         , Table.td [] [ text patient.cancer_diagnosis ]
--         , Table.td [] [ text patient.histology ]
--         , Table.td [] [ text patient.diagnosis ]
--         , Table.td [] [ text (dateToString patient.specimen_ship_date) ]
--         , Table.td [] [ text patient.adequate_for_analysis ]
--         , Table.td [] [ text patient.inadequate_details ]
--         , Table.td [] [ text (dateToString patient.date_results_returned_to_institution) ]
--         ]


renderRow : Model -> Html Msg
renderRow model =
    Table.tr []
        [ Table.td [] [ text "p1b1_ds1" ]
        , Table.td [] [ text "p1b1_es1_exp1_0004" ]
        , Table.td [] [ text "Experiment Test 4" ]
        , Table.td [] [ text "Finished" ]
        , Table.td [] [ text "2017-05-16" ]
        , Table.td [] [ text "2017-05-17" ]
        , Table.td [] [ Button.render Mdl [ 1 ] model.mdl 
            [ Button.ripple, Options.onClick (Msgs.ChangeLocation (experimentPath "p1b1_es1_exp1_0004")) ]
            [ text "view" ] ]
        ]
