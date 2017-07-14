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
import Request.Run exposing (ListConfig, defaultListConfig)
import Util
import Http
import Material
import Material.Grid as Grid
import Material.Card as Card
import Material.Options as Options exposing (css, cs, onClick, onInput)
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Table as Table
import Material.Dialog as Dialog
import DemoChart exposing (renderLineChart, renderPieChart)


-- MODEL --


type alias DialogModel =
    { title : Maybe String
    , progress : Maybe (List String)
    , parameters : Maybe (List String)
    }


type alias Model =
    { experimentInfo : Experiment
    , feed : Feed
    , listConfig : ListConfig
    , mdl : Material.Model
    , dialogModel : DialogModel
    }


init : Experiment.ExperimentId -> Task PageLoadError Model
init experimentId =
    let
        loadExperiment =
            Request.Experiment.get experimentId
                |> Http.toTask

        listConfig =
            { defaultListConfig | experiment_id = (Just experimentId) }

        loadRuns =
            Request.Run.list listConfig
                |> Http.toTask

        initMdl =
            Task.succeed Material.model

        initDialogModel =
            Task.succeed (DialogModel Nothing Nothing Nothing)

        handleLoadError _ =
            pageLoadError Page.Other "Experiment is currently unavailable."
    in
        Task.map5 Model loadExperiment loadRuns (Task.succeed listConfig) initMdl initDialogModel
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    let
        exp =
            model.experimentInfo

        title =
            (benchmarkIdToString exp.benchmark_id) ++ " > " ++ (Maybe.withDefault "" exp.experiment_title)
    in
        Grid.grid []
            [ Grid.cell [ Grid.size Grid.All 12 ]
                [ renderDialog model
                , Card.view [ css "width" "100%", css "margin" "0 10px 10px 0", Elevation.e2 ]
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
            model.feed.runsCount

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
                offset - limit
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
            model.feed.runsCount

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
                , Dialog.openOn "click"
                , onClick (OnDialogOpen run)
                ]
                [ text "detail" ]
            ]
        ]


renderDialog : Model -> Html Msg
renderDialog model =
    let
        title =
            case model.dialogModel.title of
                Just val ->
                    val

                Nothing ->
                    ""

        progressDiv =
            case model.dialogModel.progress of
                Just list ->
                    div []
                        [ h4 [] [ text "Progress" ]
                        , pre [] [ text (String.join "\n" (Maybe.withDefault [ "" ] model.dialogModel.progress)) ]
                        ]

                Nothing ->
                    text ""

        parameterDiv =
            case model.dialogModel.parameters of
                Just list ->
                    div []
                        [ h4 [] [ text "Parameters" ]
                        , ul [] (List.map (\item -> li [] [ text item ]) list)
                        ]

                Nothing ->
                    text ""
    in
        Dialog.view [ Options.css "width" "800px" ]
            [ Dialog.title [] [ text title ]
            , Dialog.content []
                [ parameterDiv
                , progressDiv
                ]
            , Dialog.actions []
                [ Button.render Mdl
                    [ 2 ]
                    model.mdl
                    [ Dialog.closeOn "click" ]
                    [ text "close" ]
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
    | OnTableSearch String
    | OnTablePaging Int
    | FeedLoadCompleted (Result Http.Error Feed)
    | OnDialogOpen Run


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

        OnDialogOpen runInfo ->
            let
                dialogModel =
                    DialogModel (Just (runIdToString runInfo.run_id)) runInfo.run_progress runInfo.parameters
            in
                ( { model | dialogModel = dialogModel }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


updateFeed : ListConfig -> Cmd Msg
updateFeed listConfig =
    Request.Run.list listConfig
        |> Http.toTask
        |> Task.attempt FeedLoadCompleted
