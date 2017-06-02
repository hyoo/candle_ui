module Request.Experiment exposing (..)

import Http
import Data.Experiment as Experiment exposing (experimentIdToString, Experiment)
import HttpBuilder exposing (withExpect, withQueryParams, RequestBuilder, withBody)
import Request.Helpers exposing (apiUrl)
import Json.Decode as Decode


-- SINGLE --


get : Experiment.ExperimentId -> Http.Request Experiment
get experimentId =
    let
        expect =
            Experiment.decoder
                |> Http.expectJson
    in
        apiUrl ("experiment/" ++ experimentIdToString experimentId)
            |> HttpBuilder.get
            |> HttpBuilder.withExpect expect
            |> HttpBuilder.toRequest



-- LIST --


type alias ListConfig =
    { limit : Int
    , offset : Int
    }


defaultListConfig : ListConfig
defaultListConfig =
    { limit = 20
    , offset = 0
    }


list : ListConfig -> Http.Request (List Experiment)
list config =
    [ ( "limit", Just (toString config.limit) )
    , ( "offset", Just (toString config.offset) )
    ]
        |> List.filterMap maybeVal
        |> buildFromQueryParams "/experiment"
        |> HttpBuilder.toRequest



-- HELPERS --


maybeVal : ( a, Maybe b ) -> Maybe ( a, b )
maybeVal ( key, value ) =
    case value of
        Nothing ->
            Nothing

        Just val ->
            Just ( key, val )


buildFromQueryParams : String -> List ( String, String ) -> RequestBuilder (List Experiment)
buildFromQueryParams url queryParams =
    let
        expect =
            Decode.list Experiment.decoder
    in
        url
            |> apiUrl
            |> HttpBuilder.get
            |> withExpect (Http.expectJson expect)
            |> withQueryParams queryParams
