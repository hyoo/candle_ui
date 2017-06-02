module Page.Experiment exposing (view, update, Model, Msg, init)

import Html exposing (..)
import Task exposing (Task)
import Views.Page as Page
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Data.Benchmark as Benchmark exposing (benchmarkIdToString)
import Data.Experiment as Experiment exposing (Experiment)
import Data.Run as Run exposing (runIdToString, Run)
import Data.Run.Feed as Feed exposing (Feed)
import Request.Experiment
import Request.Run
import Util
import Http
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
    { experimentInfo : Experiment
    , feed : Feed
    , mdl : Material.Model
    }


init : Experiment.ExperimentId -> Task PageLoadError Model
init experimentId =
    let
        loadExperiment =
            Request.Experiment.get experimentId
                |> Http.toTask

        defaultListConfig =
            Request.Run.defaultListConfig

        loadRuns =
            Request.Run.list { defaultListConfig | experiment_id = (Just experimentId) }
                |> Http.toTask

        initMdl =
            Task.succeed Material.model

        handleLoadError _ =
            pageLoadError Page.Other "Experiment is currently unavailable."
    in
        Task.map3 Model loadExperiment loadRuns initMdl
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    let
        exp =
            model.experimentInfo

        title =
            (benchmarkIdToString exp.benchmark_id) ++ " > " ++ exp.experiment_title
    in
        Grid.grid []
            [ Grid.cell [ Grid.size Grid.All 12 ]
                [ Card.view [ css "width" "100%", css "margin" "0 10px 10px 0", Elevation.e2 ]
                    [ Card.title [] [ text title ]
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
        , Table.tbody [] (List.map (renderRow model) model.feed.runs)
        ]


renderRow : Model -> Run -> Html Msg
renderRow model run =
    Table.tr []
        [ Table.td [] [ text (runIdToString run.run_id) ]
        , Table.td [] [ text (Util.formatDateTime run.start_time) ]
        , Table.td [] [ text (Util.formatDateTime run.end_time) ]
        , Table.td [] [ text (toString (Maybe.withDefault 0.0 run.runtime_hours)) ]
        , Table.td [] [ text (Maybe.withDefault "" run.status) ]
        , Table.td [] [ text (renderMaybeFloat run.training_accuracy) ]
        , Table.td [] [ text (renderMaybeFloat run.training_loss) ]
        , Table.td []
            [ Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.ripple
                ]
                [ text "detail" ]
            ]
        ]


renderMaybeFloat : Maybe Float -> String
renderMaybeFloat val =
    case val of
        Nothing ->
            "-"

        Just value ->
            toString value



-- UPDATE --


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
