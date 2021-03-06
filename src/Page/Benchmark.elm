module Page.Benchmark exposing (view, update, Model, Msg, init)

import Html exposing (..)
import Html.Attributes exposing (hidden)
import Array
import Task exposing (Task)
import Views.Page as Page
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Data.Benchmark as Benchmark exposing (Benchmark)
import Data.Experiment as Experiment exposing (Experiment, experimentIdToString)
import Data.Experiment.Feed as Feed exposing (Feed)
import Request.Benchmark
import Request.Experiment exposing (ListConfig, defaultListConfig)
import Route
import Http
import Material
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs, onClick, onInput)
import Material.Elevation as Elevation
import Material.Toggles as Toggles
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Table as Table
import Util


-- MODEL --


type alias Model =
    { benchmarkInfo : Benchmark
    , feed : Feed
    , listConfig : ListConfig
    , mdl : Material.Model
    , toggles : Array.Array Bool
    }


init : Benchmark.BenchmarkId -> Task PageLoadError Model
init benchmarkId =
    let
        loadBenchmark =
            Request.Benchmark.get benchmarkId
                |> Http.toTask

        listConfig =
            { defaultListConfig | benchmark_id = (Just benchmarkId) }

        loadExperiments =
            Request.Experiment.list listConfig
                |> Http.toTask

        initMdl =
            Task.succeed Material.model

        initToggle =
            Task.succeed (Array.fromList [ True, False ])

        handleLoadError _ =
            pageLoadError Page.Other "Benchmark is currently unavailable."
    in
        Task.map5 Model loadBenchmark loadExperiments (Task.succeed listConfig) initMdl initToggle
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
                            , text (Maybe.withDefault "" this.overview)
                            ]
                        , p []
                            [ strong [] [ text "Relationship to core problem: " ]
                            , text (Maybe.withDefault "" this.relavance)
                            ]
                        , p [ hidden (getToggleValue 0 model) ]
                            [ strong [] [ text "Expected outcome: " ]
                            , text (Maybe.withDefault "" this.expected_outcome)
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


renderListItems : String -> Maybe (List String) -> Html Msg
renderListItems title maybe_items =
    case maybe_items of
        Just items ->
            let
                list =
                    List.map (\item -> li [] [ text item ]) items
            in
                h5 []
                    [ text title
                    , ul [] list
                    ]

        Nothing ->
            text ""



{- filter -}


viewFilter : Model -> Html Msg
viewFilter model =
    Options.div []
        [ Textfield.render Mdl
            [ 1 ]
            model.mdl
            [ Textfield.label "Search table"
            , onInput OnTableSearch
            ]
            []
        , viewStatus model
        , viewBtnPrev model
        , viewBtnNext model
        ]


viewStatus : Model -> Html Msg
viewStatus model =
    let
        total =
            model.feed.experimentsCount

        limit =
            model.listConfig.limit

        offset =
            model.listConfig.offset

        start =
            toString (offset + 1)

        end =
            (if total < (offset + limit) then
                total
             else
                (offset + limit)
            )
                |> toString
    in
        text (start ++ " - " ++ end ++ " of " ++ (toString total))


viewBtnPrev : Model -> Html Msg
viewBtnPrev model =
    let
        limit =
            model.listConfig.limit

        offset =
            model.listConfig.offset

        disabled =
            offset == 0

        newOffset =
            if offset <= limit then
                0
            else
                (offset - limit)
    in
        Button.render Mdl
            [ 2 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , css "margin" "0 5px"
            , (if disabled then
                Button.disabled
               else
                Button.flat
              )
            , onClick (OnTablePaging newOffset)
            ]
            [ text "Prev" ]


viewBtnNext : Model -> Html Msg
viewBtnNext model =
    let
        total =
            model.feed.experimentsCount

        limit =
            model.listConfig.limit

        offset =
            model.listConfig.offset

        disabled =
            (total <= (offset + limit))

        newOffset =
            if total < (offset + limit) then
                total
            else
                offset + limit
    in
        Button.render Mdl
            [ 3 ]
            model.mdl
            [ Button.ripple
            , Button.colored
            , css "margin" "0 5px"
            , (if disabled then
                Button.disabled
               else
                Button.flat
              )
            , onClick (OnTablePaging newOffset)
            ]
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
        , Table.tbody [] (List.map (renderRow model) model.feed.experiments)
        ]


renderRow : Model -> Experiment -> Html Msg
renderRow model exp =
    Table.tr []
        [ Table.td [] [ text (Maybe.withDefault "" exp.dataset_id) ]
        , Table.td [] [ text (experimentIdToString exp.experiment_id) ]
        , Table.td [] [ text (Maybe.withDefault "" exp.experiment_title) ]
        , Table.td [] [ text exp.status ]
        , Table.td [] [ text (Util.formatDateTime exp.start_time) ]
        , Table.td [] [ text (Util.formatDateTime exp.end_time) ]
        , Table.td []
            [ Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.ripple
                , Button.link (Route.routeToString (Route.Experiment exp.experiment_id))
                ]
                [ text "view" ]
            ]
        ]



{- end of list -}
-- UPDATE --


type Msg
    = Mdl (Material.Msg Msg)
    | OnTableSearch String
    | OnTablePaging Int
    | FeedLoadCompleted (Result Http.Error Feed)
    | Switch Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnTableSearch str ->
            let
                keyword =
                    case str of
                        "" ->
                            Nothing

                        _ ->
                            Just str

                listConfig =
                    model.listConfig

                newListConfig =
                    { listConfig | keyword = keyword }

                subCmd =
                    updateFeed newListConfig
            in
                ( { model | listConfig = newListConfig }, subCmd )

        OnTablePaging offset ->
            let
                listConfig =
                    model.listConfig

                newListConfig =
                    { listConfig | offset = offset }

                subCmd =
                    updateFeed newListConfig
            in
                ( { model | listConfig = newListConfig }, subCmd )

        FeedLoadCompleted (Ok feed) ->
            ( { model | feed = feed }, Cmd.none )

        FeedLoadCompleted (Err error) ->
            let
                _ =
                    Debug.log "Feed error" error
            in
                ( model, Cmd.none )

        Switch k ->
            ( { model | toggles = Array.set k (getToggleValue k model |> not) model.toggles }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


getToggleValue : Int -> Model -> Bool
getToggleValue k model =
    Array.get k model.toggles |> Maybe.withDefault False


updateFeed : ListConfig -> Cmd Msg
updateFeed listConfig =
    Request.Experiment.list listConfig
        |> Http.toTask
        |> Task.attempt FeedLoadCompleted
