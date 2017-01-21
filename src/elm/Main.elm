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


-- Model


type alias Model =
    { sequenceLength : Int
    , modulus : Int
    , errorMsg : Maybe String
    }


init : Model
init =
    Model 0 0 Nothing



-- Update


type Msg
    = SetLength (Result String Int)
    | SetModulus (Result String Int)
    | GetDataToPlot


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetLength (Ok len) ->
            { model
                | sequenceLength = len
                , errorMsg = Nothing
            }

        SetModulus (Ok modulus) ->
            { model
                | modulus = modulus
                , errorMsg = Nothing
            }

        SetLength (Err errMsg) ->
            { model | errorMsg = Just errMsg }

        SetModulus (Err errMsg) ->
            { model | errorMsg = Just errMsg }

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
            , div
                [ style [ ( "color", "red" ) ] ]
                [ text <| Maybe.withDefault "" model.errorMsg ]
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
