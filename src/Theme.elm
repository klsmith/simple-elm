module Theme exposing (Theme, dark, light)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Colors exposing (..)
import Element.Font as Font


type alias Theme =
    { background : Element.Color
    , textColor : Element.Color
    , buttonBackground : Element.Color
    , buttonBorderColor : Element.Color
    , buttonTextColor : Element.Color
    , buttonBackgroundHover : Element.Color
    , buttonBorderColorHover : Element.Color
    , buttonTextColorHover : Element.Color
    , evenRowTableBackground : Element.Color
    , oddRowTableBackground : Element.Color
    , dimTextColor : Element.Color
    }


dark : Theme
dark =
    { background = zinc_900
    , textColor = zinc_300
    , buttonBackground = zinc_800
    , buttonBorderColor = zinc_300
    , buttonTextColor = zinc_300
    , buttonBackgroundHover = zinc_300
    , buttonBorderColorHover = zinc_50
    , buttonTextColorHover = zinc_900
    , evenRowTableBackground = zinc_900
    , oddRowTableBackground = zinc_800
    , dimTextColor = zinc_500
    }


light : Theme
light =
    { background = zinc_50
    , textColor = zinc_600
    , buttonBackground = zinc_100
    , buttonBorderColor = zinc_600
    , buttonTextColor = zinc_600
    , buttonBackgroundHover = zinc_600
    , buttonBorderColorHover = zinc_900
    , buttonTextColorHover = zinc_50
    , evenRowTableBackground = zinc_50
    , oddRowTableBackground = zinc_100
    , dimTextColor = zinc_400
    }
