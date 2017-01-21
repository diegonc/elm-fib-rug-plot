module Main exposing (..)

import Html
    exposing
        ( Html
        , text
        , form
        , fieldset
        , legend
        , label
        , input
        , button
        , div
        )
import Html.Attributes exposing (type_, value, style, class)
import Html.Events exposing (onInput, onSubmit)
import Api.Fibonacci exposing (ApiConf, fibSequenceRequest)
import RemoteData exposing (RemoteData(..), WebData)
import Plot exposing (rugPlot, render)


-- Model


type alias Model =
    { apiConf : ApiConf
    , sequenceLength : Int
    , modulus : Int
    , errorMsg : Maybe String
    , rawData : WebData (List Int)
    , plotData : Maybe Plot.Data
    }


init : ( Model, Cmd Msg )
init =
    ( Model (ApiConf "http://localhost:8001") 0 0 Nothing NotAsked Nothing, Cmd.none )



-- Update


type Msg
    = SetLength (Result String Int)
    | SetModulus (Result String Int)
    | GetDataToPlot
    | GotDataToPlot (WebData (List Int))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLength (Ok len) ->
            ( { model
                | sequenceLength = len
                , errorMsg = Nothing
              }
            , Cmd.none
            )

        SetModulus (Ok modulus) ->
            ( { model
                | modulus = modulus
                , errorMsg = Nothing
              }
            , Cmd.none
            )

        SetLength (Err errMsg) ->
            ( { model | errorMsg = Just errMsg }, Cmd.none )

        SetModulus (Err errMsg) ->
            ( { model | errorMsg = Just errMsg }, Cmd.none )

        GetDataToPlot ->
            let
                { sequenceLength, modulus, apiConf } =
                    model
            in
                ( { model
                    | rawData = Loading
                    , plotData = Nothing
                  }
                , fibSequenceRequest apiConf sequenceLength modulus
                    |> RemoteData.sendRequest
                    |> Cmd.map GotDataToPlot
                )

        GotDataToPlot ((Success points) as data) ->
            let
                minTick =
                    0

                maxTick =
                    model.modulus
            in
                ( { model
                    | rawData = data
                    , plotData = Just <| rugPlot minTick maxTick points
                    , errorMsg = Nothing
                  }
                , Cmd.none
                )

        GotDataToPlot ((Failure err) as data) ->
            ( { model
                | rawData = data
                , errorMsg = Just <| toString err
              }
            , Cmd.none
            )

        GotDataToPlot data ->
            ( { model | rawData = data }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ viewSettingsForm model
        , viewPlot model.plotData
        ]


viewSettingsForm : Model -> Html Msg
viewSettingsForm model =
    Html.form [ onSubmit GetDataToPlot ]
        [ fieldset []
            [ legend [] [ text "Settings" ]
            , label [] [ text "Length" ]
            , input
                [ type_ "number"
                , value <| toString model.sequenceLength
                , onInput <| String.toInt >> SetLength
                ]
                []
            , label [] [ text "Modulus" ]
            , input
                [ type_ "number"
                , value <| toString model.modulus
                , onInput <| String.toInt >> SetModulus
                ]
                []
            , button [] [ text "Plot" ]
            , div
                [ style [ ( "color", "red" ) ] ]
                [ text <| Maybe.withDefault "" model.errorMsg ]
            ]
        ]


viewPlot : Maybe Plot.Data -> Html Msg
viewPlot plotData =
    div [ class "plot" ]
        [ plotData
            |> Maybe.map (render (Plot.Config 400 150))
            |> Maybe.withDefault (text "")
        ]



-- Program


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
