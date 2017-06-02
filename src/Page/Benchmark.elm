module Page.Benchmark exposing (view, update, Model, Msg, init)

import Html exposing (..)
import Html.Attributes exposing (hidden)
import Array
import Task exposing (Task)
import Views.Page as Page
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Data.Benchmark as Benchmark exposing (Benchmark)
import Request.Benchmark
import Http
import Material
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs)
import Material.Elevation as Elevation
import Material.Toggles as Toggles
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Table as Table


-- MODEL --


type alias Model =
    { benchmarkInfo : Benchmark
    , mdl : Material.Model
    , toggles : Array.Array Bool
    }


init : Benchmark.BenchmarkId -> Task PageLoadError Model
init benchmarkId =
    let
        loadBenchmark =
            Request.Benchmark.get benchmarkId
                |> Http.toTask

        initMdl =
            Task.succeed Material.model

        initToggle =
            Task.succeed (Array.fromList [ True, False ])

        handleLoadError _ =
            pageLoadError Page.Other "Benchmark is currently unavailable."
    in
        Task.map3 Model loadBenchmark initMdl initToggle
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    let
        this =
            model.benchmarkInfo

        title =
            (Benchmark.benchmarkIdToString this.benchmark_id) ++ ": " ++ this.benchmark_title
    in
        Grid.grid []
            [ Grid.cell [ Grid.size Grid.All 12 ]
                [ Card.view [ css "width" "100%", css "margin" "0 10px 10px 0", Elevation.e2 ]
                    [ Card.title [] [ text title ]
                    , Card.text []
                        [ p []
                            [ strong [] [ text "Overview: " ]
                            , text this.overview
                            ]
                        , p []
                            [ strong [] [ text "Relationship to core problem: " ]
                            , text this.relavance
                            ]
                        , p [ hidden (getToggleValue 0 model) ]
                            [ strong [] [ text "Expected outcome: " ]
                            , text this.expected_outcome
                            ]
                        , p [ hidden (getToggleValue 0 model) ] [ h4 [] [ text "Benchmark Specs Requirements" ] ]
                        , p [ hidden (getToggleValue 0 model) ]
                            [ renderListItems "Description of the Data"
                                this.data_description
                            ]
                        , p [ hidden (getToggleValue 0 model) ]
                            [ renderListItems "Expected Outcomes"
                                this.expected_outcomes
                            ]
                        , p [ hidden (getToggleValue 0 model) ]
                            [ renderListItems "Evaluation Metrics"
                                this.evaluation_metrics
                            ]
                        , p [ hidden (getToggleValue 0 model) ]
                            [ renderListItems "Description of the Network"
                                this.network_description
                            ]
                        , Toggles.switch Mdl
                            [ 0 ]
                            model.mdl
                            [ Options.onToggle (Switch 0)
                            , Toggles.ripple
                            , Toggles.value (not (getToggleValue 0 model))
                            ]
                            [ text "see more" ]
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



{- end of filter -}
{- list -}


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
        , Table.td []
            [ Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.ripple, Button.link "/#experiment/p1b1_es1_exp1_0004" ]
                [ text "view" ]
            ]
        ]



{- end of list -}
-- UPDATE --


type Msg
    = Mdl (Material.Msg Msg)
    | Switch Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Switch k ->
            ( { model | toggles = Array.set k (getToggleValue k model |> not) model.toggles }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


getToggleValue : Int -> Model -> Bool
getToggleValue k model =
    Array.get k model.toggles |> Maybe.withDefault False
