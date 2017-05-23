module Main exposing (..)

import Html exposing (..)
import Navigation exposing (Location)
import Views.Page as Page exposing (ActivePage)
import Page.Home as Home
import Page.Benchmark as Benchmark
import Page.Experiment as Experiment
import Page.Errored as Errored exposing (PageLoadError)
import Page.NotFound as NotFound
import Task
import Route exposing (Route)


type Page
    = Blank
    | NotFound
    | Errored PageLoadError
    | Home Home.Model
    | Benchmark Benchmark.Model
    | Experiment Experiment.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --


type alias Model =
    { pageState : PageState }


init : Location -> ( Model, Cmd Msg )
init location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage }


initialPage : Page
initialPage =
    Blank


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    let
        frame =
            Page.frame isLoading
    in
        case page of
            NotFound ->
                NotFound.view
                    |> frame Page.Other

            Blank ->
                Html.text ""
                    |> frame Page.Other

            Errored subModel ->
                Errored.view subModel
                    |> frame Page.Other

            Home subModel ->
                Home.view subModel
                    |> frame Page.Home
                    |> Html.map HomeMsg

            Benchmark subModel ->
                Benchmark.view subModel
                    |> frame Page.Benchmark
                    |> Html.map BenchmarkMsg

            Experiment subModel ->
                Experiment.view subModel
                    |> frame Page.Experiment
                    |> Html.map ExperimentMsg



-- element : Model -> Html Msg
-- element model =
--     Dialog.view [ Options.css "width" "800px" ]
--         [ Dialog.title [] [ text "p1b1_es1_exp1_0004.0203" ]
--         , Dialog.content []
--             [ pre [] [ text """
-- Using Theano backend.
-- Using cuDNN version 5110 on context None
-- Mapped name None to device cuda: Tesla K80 (0000:07:00.0)
-- Epoch 1/2
-- 2400/2400 [==============================] - 6s - loss: 0.0420 - val_loss: 0.0385
-- Epoch 2/2
-- 2400/2400 [==============================] - 6s - loss: 0.0377 - val_loss: 0.0378
-- """ ]
--             ]
--         , Dialog.actions []
--             [ Button.render Msgs.Mdl
--                 [ 2 ]
--                 model.mdl
--                 [ Dialog.closeOn "click" ]
--                 [ text "close" ]
--             ]
--         ]
-- benchmarkView : String -> Html msg
-- benchmarkView id =
--     div [] [ text ("viewing benchmark " ++ id) ]


getPage : PageState -> Page
getPage pageStage =
    case pageStage of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]



-- UPDATE --


type Msg
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | HomeMsg Home.Msg
    | BenchmarkLoaded (Result PageLoadError Benchmark.Model)
    | BenchmarkMsg Benchmark.Msg
    | ExperimentLoaded (Result PageLoadError Experiment.Model)
    | ExperimentMsg Experiment.Msg


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            ( { model | pageState = TransitioningFrom (getPage model.pageState) }, Task.attempt toMsg task )

        errored =
            pageErrored model
    in
        case maybeRoute of
            Nothing ->
                ( { model | pageState = Loaded NotFound }, Cmd.none )

            Just Route.Home ->
                transition HomeLoaded (Home.init)

            Just (Route.Benchmark id) ->
                transition BenchmarkLoaded (Benchmark.init id)

            Just (Route.Experiment id) ->
                transition ExperimentLoaded (Experiment.init id)


pageErrored : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            Errored.pageLoadError activePage errorMessage
    in
        ( { model | pageState = Loaded (Errored error) }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        errored =
            pageErrored model
    in
        case ( msg, page ) of
            ( SetRoute route, _ ) ->
                setRoute route model

            ( HomeLoaded (Ok subModel), _ ) ->
                ( { model | pageState = Loaded (Home subModel) }, Cmd.none )

            ( HomeLoaded (Err error), _ ) ->
                ( { model | pageState = Loaded (Errored error) }, Cmd.none )

            ( HomeMsg subMsg, Home subModel ) ->
                toPage Home HomeMsg (Home.update) subMsg subModel

            ( BenchmarkLoaded (Ok subModel), _ ) ->
                ( { model | pageState = Loaded (Benchmark subModel) }, Cmd.none )

            ( BenchmarkLoaded (Err error), _ ) ->
                ( { model | pageState = Loaded (Errored error) }, Cmd.none )

            ( BenchmarkMsg subMsg, Benchmark subModel ) ->
                toPage Benchmark BenchmarkMsg (Benchmark.update) subMsg subModel

            ( ExperimentLoaded (Ok subModel), _ ) ->
                ( { model | pageState = Loaded (Experiment subModel) }, Cmd.none )

            ( ExperimentLoaded (Err error), _ ) ->
                ( { model | pageState = Loaded (Errored error) }, Cmd.none )

            ( ExperimentMsg subMsg, Experiment subModel ) ->
                toPage Experiment ExperimentMsg (Experiment.update) subMsg subModel

            ( _, NotFound ) ->
                ( model, Cmd.none )

            ( _, _ ) ->
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
