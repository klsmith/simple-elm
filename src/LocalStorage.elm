port module LocalStorage exposing (Msg(..), load, save, subscribe)

import Json.Decode as Decode exposing (Decoder, Error, Value, andThen, decodeValue, field, string, value)
import Json.Encode as Encode
import Result



-- PORTS


port localStorageSavePort : { key : String, value : String } -> Cmd msg


port localStorageLoadPort : String -> Cmd msg


port localStorageMsgPort : (Value -> msg) -> Sub msg



-- TYPES


type Msg
    = OnLoad String Value
    | ParseError Error



-- INTERFACE


save : String -> Value -> Cmd msg
save key value =
    localStorageSavePort
        { key = key
        , value = Encode.encode 0 value
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
        "OnLoad" ->
            Decode.map2 OnLoad
                (field "key" string)
                (field "value" string
                    |> andThen decodeStringAsValue
                )

        _ ->
            Decode.fail
                ("Unknown Message Type: " ++ msgType)


decodeStringAsValue : String -> Decoder Value
decodeStringAsValue string =
    case Decode.decodeString Decode.value string of
        Ok value ->
            Decode.succeed value

        _ ->
            Decode.fail "Expected a stringified JSON value here."
