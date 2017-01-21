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
        )
import Html.Attributes exposing (type_, value, style)
import Html.Events exposing (onInput, onSubmit)


-- Model


type alias Model =
    { sequenceLength : Int
    , modulus : Int
    }


init : Model
init =
    Model 0 0



-- Update


type Msg
    = SetLength (Result String Int)
    | SetModulus (Result String Int)
    | GetDataToPlot


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetLength (Ok len) ->
            { model | sequenceLength = len }

        SetModulus (Ok modulus) ->
            { model | modulus = modulus }

        SetLength (Err errMsg) ->
            model

        SetModulus (Err errMsg) ->
            model

        GetDataToPlot ->
            model



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
            ]
        ]



-- Program


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
