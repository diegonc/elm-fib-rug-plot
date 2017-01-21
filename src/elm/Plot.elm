module Plot exposing (Data, Config, rugPlot, render)

import Html exposing (Html)
import Set exposing (Set)
import Svg exposing (..)
import Svg.Attributes exposing (..)


type alias Config =
    { width : Int
    , height : Int
    }


type alias RugData =
    { ticks : Set Int
    , firstTick : Int
    , lastTick : Int
    }


type Data
    = Rug RugData


rugPlot : Int -> Int -> List Int -> Data
rugPlot firstTick lastTick points =
    Rug
        { ticks = Set.fromList points
        , firstTick = firstTick
        , lastTick = lastTick
        }


render : Config -> Data -> Html a
render config data =
    case data of
        Rug rugData ->
            renderRugPlot config rugData


{-| An arbitrary height used to define the viewbox
-}
rugUserHeight : Int
rugUserHeight =
    100


renderRugPlot : Config -> RugData -> Html a
renderRugPlot config rugData =
    rugData.ticks
        |> Set.toList
        |> List.map rugRenderTick
        |> svg
            [ width <| toString config.width
            , height <| toString config.height
            , viewBox <| rugComputeViewBox rugData
            , preserveAspectRatio "none"
            ]


rugComputeViewBox : RugData -> String
rugComputeViewBox rugData =
    let
        minX =
            rugData.firstTick

        minY =
            0

        width =
            rugData.lastTick - rugData.firstTick + 1

        height =
            rugUserHeight
    in
        [ minX, minY, width, height ]
            |> List.map toString
            |> String.join " "


rugRenderTick : Int -> Svg a
rugRenderTick x =
    line
        [ x1 <| toString x
        , x2 <| toString x
        , y1 "0"
        , y2 <| toString rugUserHeight
        , strokeWidth "1"
        , stroke "black"
        ]
        []
