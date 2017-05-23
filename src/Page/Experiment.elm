module Page.Experiment exposing (view, update, Model, Msg, init)

import Html exposing (..)
import Task exposing (Task)
import Views.Page as Page
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Material
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs)
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Table as Table
import DemoChart exposing (renderLineChart, renderPieChart)


-- MODEL --


type alias Model =
    { experimentInfo : List String
    , mdl : Material.Model
    }


init : String -> Task PageLoadError Model
init experimentId =
    let
        loadExperiment =
            Task.succeed [ "" ]

        initMdl =
            Task.succeed Material.model

        handleLoadError _ =
            pageLoadError Page.Other "Benchmark is currently unavailable."
    in
        Task.map2 Model loadExperiment initMdl
            |> Task.mapError handleLoadError



-- VIEW --


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
                    [ viewFilter model
                    , renderTable model
                    ]
                ]
            ]
        ]



{- filter -}


viewFilter : Model -> Html Msg
viewFilter model =
    Options.div []
        [ Textfield.render Mdl
            [ 1 ]
            model.mdl
            [ Textfield.label "Search table" ]
            []
        , viewStatus model
        , viewBtnPrev model
        , viewBtnNext model
        ]


viewStatus : Model -> Html Msg
viewStatus model =
    text "1 - 25 of xxx "


viewBtnPrev : Model -> Html Msg
viewBtnPrev model =
    Button.render Mdl
        [ 2 ]
        model.mdl
        [ Button.ripple, Button.colored, css "margin" "0 5px" ]
        [ text "Prev" ]


viewBtnNext : Model -> Html Msg
viewBtnNext model =
    Button.render Mdl
        [ 3 ]
        model.mdl
        [ Button.ripple, Button.colored, css "margin" "0 5px" ]
        [ text "Next" ]



{- list -}


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
        , Table.td []
            [ Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.ripple --, Options.onClick (Msgs.ChangeLocation (experimentPath "p1b1_es1_exp1_0004"))

                -- , Dialog.openOn "click"
                ]
                [ text "detail" ]
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
