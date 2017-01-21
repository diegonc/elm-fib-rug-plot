module Api.Fibonacci exposing (ApiConf, fibSequenceRequest)

import Http exposing (Request)
import Json.Decode as Decode exposing (Decoder)


fibEndpoint : String
fibEndpoint =
    "/fib-seq/"


type alias ApiConf =
    { host : String }


decodeFibList : Decoder (List Int)
decodeFibList =
    Decode.field "data" <| Decode.list Decode.int


fibSequenceRequest : ApiConf -> Int -> Int -> Request (List Int)
fibSequenceRequest conf len modulus =
    let
        url =
            conf.host
                ++ fibEndpoint
                ++ toString len
                ++ "?modulo="
                ++ toString modulus
    in
        Http.get url decodeFibList
