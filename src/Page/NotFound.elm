module Page.NotFound exposing (view)

import Html exposing (Html, main_, h1, div, text)
import Html.Attributes exposing (class, tabindex, id)


view : Html msg
view =
    main_ [ id "content", class "container", tabindex -1 ]
        [ h1 [] [ text "Not Found" ] ]
