port module LocalStorage exposing (load, save, subscribe)

import Json.Decode as Decode exposing (Decoder, Error, Value, andThen, decodeValue, field, string, value)
import Json.Encode as Encode



-- PORTS


port localStorageSavePort : { key : String, value : String } -> Cmd msg


port localStorageLoadPort : String -> Cmd msg


port localStorageMsgPort : (Value -> msg) -> Sub msg



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


subscribe : (Result Decode.Error ( String, Value ) -> msg) -> Sub msg
subscribe toExternalMsg =
    localStorageMsgPort
        (toExternalMsg << decodeValue msgDecoder)


msgDecoder : Decoder ( String, Value )
msgDecoder =
    Decode.map2 Tuple.pair
        (field "key" string)
        (field "value" string
            |> andThen decodeStringAsValue
        )


decodeStringAsValue : String -> Decoder Value
decodeStringAsValue string =
    case Decode.decodeString Decode.value string of
        Ok value ->
            Decode.succeed value

        _ ->
            Decode.fail "Expected a stringified JSON value here."
