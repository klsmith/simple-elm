module Fonts exposing (..)

import Element exposing (Attribute)
import Element.Font as Font


bookInsanity : Attribute msg
bookInsanity =
    Font.family
        [ Font.typeface "Bookinsanity"
        , Font.serif
        ]


scalySans : Attribute msg
scalySans =
    Font.family
        [ Font.typeface "Scaly Sans"
        , Font.sansSerif
        ]


nodestoCapsCondensed : Attribute msg
nodestoCapsCondensed =
    Font.family
        [ Font.typeface "Nodesto Caps Condensed"
        , Font.serif
        ]


zatannaMisdirection : Attribute msg
zatannaMisdirection =
    Font.family
        [ Font.typeface "Zatanna Misdirection"
        , Font.sansSerif
        ]
