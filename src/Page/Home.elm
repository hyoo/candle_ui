module Page.Home exposing (view, update, Model, Msg, init)

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Views.Page as Page
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Data.Benchmark as Benchmark exposing (Benchmark, benchmarkIdToString)
import Data.Benchmark.Feed as Feed exposing (Feed)
import Request.Benchmark
import Route
import Http
import Material
import Material.Card as Card
import Material.Grid as Grid
import Material.Button as Button
import Material.Elevation as Elevation
import Material.Options as Options exposing (css, cs, attribute)
import DemoChart


-- MODEL --


type alias Mdl =
    Material.Model


type alias Model =
    { feed : Feed
    , mdl : Material.Model
    }


init : Task PageLoadError Model
init =
    let
        defaultListConfig =
            Request.Benchmark.defaultListConfig

        loadSources =
            Request.Benchmark.list defaultListConfig
                |> Http.toTask

        mdl =
            Task.succeed Material.model

        handleLoadError _ =
            pageLoadError Page.Home "Homepage is currently unavailable"
    in
        Task.map2 Model loadSources mdl
            |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html Msg
view model =
    Grid.grid []
        (Grid.cell [ Grid.size Grid.All 12 ]
            [ Card.view [ css "width" "100%", css "height" "260px", Elevation.e2 ]
                [ Card.text []
                    [ div [ class "demo-graph" ] [ DemoChart.renderLineChart ]
                    ]
                ]
            ]
            :: viewBenchmarks model
        )


viewBenchmarks : Model -> List (Grid.Cell Msg)
viewBenchmarks model =
    List.map (viewBenchmarkCard model) model.feed.benchmarks


viewBenchmarkCard : Model -> Benchmark -> Grid.Cell Msg
viewBenchmarkCard model benchmark =
    Grid.cell [ Grid.size Grid.All 4 ]
        [ Card.view [ Elevation.e2 ]
            [ Card.title [] [ Card.head [] [ text (benchmarkIdToString benchmark.benchmark_id) ] ]
            , Card.text []
                [ text benchmark.benchmark_title
                ]
            , Card.actions [ Card.border ]
                [ Button.render Mdl
                    [ 1, 0 ]
                    model.mdl
                    [ Button.ripple
                    , Button.accent
                    , Button.link (Route.routeToString (Route.Benchmark benchmark.benchmark_id))
                    ]
                    [ text "read more" ]
                ]
            ]
        ]



-- UPDATE --


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
