module Theme exposing (Theme, dark, light)

import Element
import Element.Colors exposing (..)


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
    { background = neutral_900
    , textColor = neutral_300
    , buttonBackground = neutral_800
    , buttonBorderColor = neutral_300
    , buttonTextColor = neutral_300
    , buttonBackgroundHover = neutral_300
    , buttonBorderColorHover = neutral_50
    , buttonTextColorHover = neutral_900
    , evenRowTableBackground = neutral_900
    , oddRowTableBackground = neutral_800
    , dimTextColor = neutral_500
    }


light : Theme
light =
    { background = neutral_50
    , textColor = neutral_600
    , buttonBackground = neutral_100
    , buttonBorderColor = neutral_600
    , buttonTextColor = neutral_600
    , buttonBackgroundHover = neutral_600
    , buttonBorderColorHover = neutral_900
    , buttonTextColorHover = neutral_50
    , evenRowTableBackground = neutral_50
    , oddRowTableBackground = neutral_100
    , dimTextColor = neutral_400
    }
