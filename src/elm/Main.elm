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
import Html.Attributes exposing (type_, value, style)
import Html.Events exposing (onInput, onSubmit)
import Api.Fibonacci exposing (ApiConf, fibSequenceRequest)
import RemoteData exposing (RemoteData(..), WebData)


-- Model


type alias Model =
    { apiConf : ApiConf
    , sequenceLength : Int
    , modulus : Int
    , errorMsg : Maybe String
    , rawData : WebData (List Int)
    }


init : ( Model, Cmd Msg )
init =
    ( Model (ApiConf "http://localhost:8001") 0 0 Nothing NotAsked, Cmd.none )



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
                ( { model | rawData = Loading }
                , fibSequenceRequest apiConf sequenceLength modulus
                    |> RemoteData.sendRequest
                    |> Cmd.map GotDataToPlot
                )

        GotDataToPlot data ->
            ( { model | rawData = data }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
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



-- Program


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
