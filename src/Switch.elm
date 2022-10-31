module Switch exposing (Switch(..), fromBool, selectFrom, selectWith, toBool, toggle)


type Switch
    = On
    | Off


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


toBool : Switch -> Bool
toBool =
    selectFrom ( True, False )


fromBool : Bool -> Switch
fromBool bool =
    case bool of
        True ->
            On

        False ->
            Off
