module Main exposing (..)

import Html exposing (..)
import Html.Attributes
import Array
import Msgs exposing (Msg)
import Models exposing (Model, initModel, getToggleValue)
import Material
import Material.Scheme
import Material.Color
import Material.Layout as Layout
import Material.Options as Options
import Material.Dialog as Dialog
import Material.Button as Button
import Routing exposing (parseLocation)
import Navigation exposing (Location)
import Dash
import Benchmark.Overview as Benchmark
import Experiment.Overview as Experiment


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initModel currentRoute, Cmd.none )


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Material.Color.BlueGrey Material.Color.Orange <|
        Layout.render Msgs.Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer

            -- , Layout.selectedTab model.selectedTab
            -- , Layout.onSelectTab Msg.SelectTab
            ]
            { header = []
            , drawer =
                [ Layout.title [] [ text "ECP-CANDLE" ]
                , Layout.navigation []
                    [ Layout.link [ Layout.href "/" ] [ text "Home" ]
                    , Layout.link [] [ text "Benchmarks" ]
                    , Layout.link [] [ text "Experiments" ]

                    -- , Layout.spacer
                    -- , Layout.row [] [ text "Links" ]
                    , Layout.link [ Layout.href "https://github.com/ECP-CANDLE", Options.attribute <| Html.Attributes.target "_blank" ] [ text "Github" ]
                    , Layout.link [ Layout.href "https://exascaleproject.org/", Options.attribute <| Html.Attributes.target "_blank" ] [ text "Exascale Computing Project" ]
                    ]
                ]
            , tabs = ( [], [] )
            , main =
                [ page model
                , element model
                ]

            -- , main = [ viewBody model ]
            }


page : Model -> Html Msg
page model =
    case model.route of
        Models.BenchmarksRoute ->
            Dash.view model

        Models.BenchmarkRoute id ->
            Benchmark.view model

        Models.ExperimentRoute id ->
            Experiment.view model

        Models.NotFoundRoute ->
            notFoundView


element : Model -> Html Msg
element model =
    Dialog.view [ Options.css "width" "800px" ]
        [ Dialog.title [] [ text "p1b1_es1_exp1_0004.0203" ]
        , Dialog.content []
            [ pre [] [ text """
Using Theano backend.
Using cuDNN version 5110 on context None
Mapped name None to device cuda: Tesla K80 (0000:07:00.0)
Epoch 1/2
2400/2400 [==============================] - 6s - loss: 0.0420 - val_loss: 0.0385
Epoch 2/2
2400/2400 [==============================] - 6s - loss: 0.0377 - val_loss: 0.0378
""" ]
            ]
        , Dialog.actions []
            [ Button.render Msgs.Mdl
                [ 2 ]
                model.mdl
                [ Dialog.closeOn "click" ]
                [ text "close" ]
            ]
        ]


benchmarkView : String -> Html msg
benchmarkView id =
    div [] [ text ("viewing benchmark " ++ id) ]


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Msgs.Switch k ->
            ( { model | toggles = Array.set k (getToggleValue k model |> not) model.toggles }, Cmd.none )

        Msgs.ChangeLocation path ->
            ( model, Navigation.newUrl path )

        Msgs.Mdl msg_ ->
            Material.update Msgs.Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
