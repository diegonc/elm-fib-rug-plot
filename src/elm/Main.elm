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
import Html.Attributes exposing (type_)


-- View


view : a -> Html msg
view _ =
    Html.form []
        [ fieldset []
            [ legend [] [ text "Settings" ]
            , label [] [ text "Length" ]
            , input [ type_ "number" ] []
            , label [] [ text "Modulus" ]
            , input [ type_ "number" ] []
            , button [] [ text "Plot" ]
            ]
        ]



-- Program


main : Program Never () msg
main =
    Html.beginnerProgram
        { model = ()
        , update = curry Tuple.second
        , view = view
        }
