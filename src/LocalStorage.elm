port module LocalStorage exposing (Msg(..), load, save, subscribe)

import Json.Decode as Decode exposing (Decoder, Error, Value, andThen, decodeValue, field, string, value)
import Result



-- PORTS


port localStorageSavePort : { key : String, value : Value } -> Cmd msg


port localStorageLoadPort : String -> Cmd msg


port localStorageMsgPort : (Value -> msg) -> Sub msg



-- TYPES


type Msg
    = SaveError String
    | LoadError String
    | OnLoad String Value
    | ParseError Error



-- INTERFACE


save : String -> Value -> Cmd msg
save key value =
    localStorageSavePort
        { key = key
        , value = value
        }


load : String -> Cmd msg
load =
    localStorageLoadPort


subscribe : (Msg -> msg) -> Sub msg
subscribe toExternalMsg =
    localStorageMsgPort
        (toExternalMsg << decodeMsg)


decodeMsg : Value -> Msg
decodeMsg value =
    case decodeValue msgDecoder value of
        Ok msg ->
            msg

        Err err ->
            ParseError err


msgDecoder : Decoder Msg
msgDecoder =
    field "type" string
        |> andThen msgDecoderFromType


msgDecoderFromType : String -> Decoder Msg
msgDecoderFromType msgType =
    case msgType of
        "SaveError" ->
            Decode.map SaveError
                (field "message" string)

        "LoadError" ->
            Decode.map LoadError
                (field "message" string)

        "OnLoad" ->
            Decode.map2 OnLoad
                (field "key" string)
                (field "value" value)

        _ ->
            Decode.fail
                ("Unknown Message Type: " ++ msgType)
