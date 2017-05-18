module Experiment.Filter exposing (..)


import Models exposing (..)
import Msgs exposing (..)
import Html exposing (..)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options exposing (css, onClick)


view : Model -> Html Msg 
view model =
    Options.div []
    [ Textfield.render Mdl [1] model.mdl 
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
    Button.render Mdl [2] model.mdl 
    [ Button.ripple, Button.colored, css "margin" "0 5px"]
    [ text "Prev" ]

viewBtnNext : Model -> Html Msg 
viewBtnNext model =
    Button.render Mdl [3] model.mdl 
    [ Button.ripple, Button.colored, css "margin" "0 5px"]
    [ text "Next" ]