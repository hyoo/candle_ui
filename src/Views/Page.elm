module Views.Page exposing (frame, ActivePage(..), bodyId)

{-| layout frame
-}

import Route exposing (Route)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Scheme
import Material.Color


type ActivePage
    = Other
    | Home
    | Benchmark
    | Experiment



-- | Run


frame : Bool -> ActivePage -> Html msg -> Html msg
frame isLoading page content =
    Material.Scheme.topWithScheme Material.Color.BlueGrey Material.Color.Orange <|
        div [ class "page-frame" ]
            [ viewHeader page isLoading
            , content

            -- viewFooter
            ]


viewHeader : ActivePage -> Bool -> Html msg
viewHeader page isLoading =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.href Route.Home ] [ text "ECP-CANDLE" ]
            , ul [ class "nav navbar-nav" ] [ (navbarLink (page == Home) Route.Home [ text "Home" ]) ]
            ]
        ]


navbarLink : Bool -> Route -> List (Html msg) -> Html msg
navbarLink isActive route linkContent =
    li [ classList [ ( "nav-item", True ), ( "active", isActive ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


bodyId : String
bodyId =
    "page-body"
