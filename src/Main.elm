module Main exposing (main)

import Browser exposing (Document)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Colors exposing (..)
import Element.Font as Font
import Element.Input as Input exposing (button)
import Element.Region as Region
import FeatherIcons as Icon
import File exposing (File)
import File.Select
import Html exposing (Html)
import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import LocalStorage
import Switch exposing (Switch)
import Task
import Theme exposing (Theme)
import Util


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Flags =
    ()


type alias Model =
    { fileText : Maybe String
    , light : Switch
    , loaded : Value
    }


type Msg
    = DoNothing
    | OpenJsonButtonPressed
    | FileSelected File
    | FileTextRead String
    | ToggleLight
    | TestLoaded Value


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { fileText = Nothing
      , light = Switch.Off
      , loaded = Encode.int 0
      }
    , Cmd.batch [ LocalStorage.load "fileText" ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        OpenJsonButtonPressed ->
            ( model
            , File.Select.file [ ".json" ] FileSelected
            )

        FileSelected file ->
            ( model
            , Task.perform FileTextRead <| File.toString file
            )

        FileTextRead fileText ->
            ( { model | fileText = Just fileText }
            , LocalStorage.save "fileText" <| Encode.string fileText
            )

        ToggleLight ->
            ( { model | light = Switch.toggle model.light }
            , Cmd.none
            )

        TestLoaded value ->
            ( { model | loaded = value }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    LocalStorage.subscribe handleLocalStorageMsg


handleLocalStorageMsg : LocalStorage.Msg -> Msg
handleLocalStorageMsg lsm =
    case lsm of
        LocalStorage.OnLoad _ value ->
            value
                |> attemptAsString
                |> Maybe.map FileTextRead
                |> Maybe.withDefault DoNothing

        _ ->
            DoNothing


attemptAsString : Value -> Maybe String
attemptAsString value =
    case Decode.decodeValue Decode.string value of
        Ok string ->
            Just string

        _ ->
            Nothing


fontBookInsanity =
    Font.family
        [ Font.typeface "Bookinsanity"
        , Font.serif
        ]


fontScalySans =
    Font.family
        [ Font.typeface "Scaly Sans"
        , Font.sansSerif
        ]


fontNodestoCapsCondesnsed =
    Font.family
        [ Font.typeface "Nodesto Caps Condensed"
        , Font.serif
        ]


fontZatannaMisdirection =
    Font.family
        [ Font.typeface "Zatanna Misdirection"
        , Font.sansSerif
        ]


view : Model -> Document Msg
view model =
    let
        theme =
            ( Theme.light, Theme.dark )
                |> Switch.selectWith model.light

        { fileText } =
            model
    in
    { title = "Elm App"
    , body =
        [ layout
            [ width fill
            , height fill
            , padding 16
            , Font.size 24
            , fontScalySans
            , Background.color theme.background
            , Font.color theme.textColor
            ]
          <|
            column [ spacing 16, width fill ]
                [ row
                    [ spacing 16
                    , width fill
                    ]
                    [ title "D&D - CHARACTER TRACKER"
                    , el [ alignRight ] <| lightButton model.light
                    ]
                , selectFileButton theme
                , el [ fontZatannaMisdirection ]
                    (Util.viewFileText theme fileText)
                ]
        ]
    }


title : String -> Element msg
title string =
    el
        [ Region.heading 1
        , Font.size 48
        , fontNodestoCapsCondesnsed
        ]
    <|
        text string


lightButton : Switch -> Element Msg
lightButton light =
    Input.button [ padding 8 ]
        { onPress = Just ToggleLight
        , label =
            ( Icon.moon, Icon.sun )
                |> Switch.selectWith light
                |> Icon.toHtml []
                |> Element.html
        }


selectFileButton : Theme -> Element Msg
selectFileButton theme =
    Input.button
        [ Border.width 1
        , padding 8
        , Background.color theme.buttonBackground
        , Border.color theme.buttonBorderColor
        , Font.color theme.buttonTextColor
        , mouseOver
            [ Background.color theme.buttonBackgroundHover
            , Border.color theme.buttonBorderColorHover
            , Font.color theme.buttonTextColorHover
            ]
        ]
        { onPress = Just OpenJsonButtonPressed
        , label = text "Select File"
        }
