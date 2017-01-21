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
import Html.Attributes exposing (type_, value, defaultValue)


-- Model


type alias Model =
    { sequenceLength : Int
    , modulus : Int
    }


init : Model
init =
    Model 0 0



-- View


view : Model -> Html msg
view model =
    Html.form []
        [ fieldset []
            [ legend [] [ text "Settings" ]
            , label [] [ text "Length" ]
            , input
                [ type_ "number"
                , defaultValue <| toString model.sequenceLength
                ]
                []
            , label [] [ text "Modulus" ]
            , input
                [ type_ "number"
                , defaultValue <| toString model.modulus
                ]
                []
            , button [] [ text "Plot" ]
            ]
        ]



-- Program


main : Program Never Model msg
main =
    Html.beginnerProgram
        { model = init
        , update = curry Tuple.second
        , view = view
        }
