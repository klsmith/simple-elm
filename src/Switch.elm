module Switch exposing
    ( Switch(..)
    , decoder
    , encode
    , fromBool
    , selectFrom
    , selectWith
    , toBool
    , toggle
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)



-- TYPE


type Switch
    = On
    | Off



-- INTERFACE


selectFrom : ( a, a ) -> Switch -> a
selectFrom ( onOpt, offOpt ) switch =
    case switch of
        On ->
            onOpt

        Off ->
            offOpt


selectWith : Switch -> ( a, a ) -> a
selectWith switch tuple =
    selectFrom tuple switch


toggle : Switch -> Switch
toggle =
    selectFrom ( Off, On )



-- BOOL CONVERSION


toBool : Switch -> Bool
toBool =
    selectFrom ( True, False )


fromBool : Bool -> Switch
fromBool bool =
    if bool then
        On

    else
        Off



-- JSON ENCODE/DECODE


encode : Switch -> Value
encode =
    Encode.bool << toBool


decoder : Decoder Switch
decoder =
    Decode.map fromBool Decode.bool
