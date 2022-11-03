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
import Fonts
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
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
    | LoadLight Switch
    | LogError String


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { fileText = Nothing
      , light = Switch.Off
      , loaded = Encode.int 0
      }
    , Cmd.batch
        [ LocalStorage.load "fileText"
        , LocalStorage.load "light"
        ]
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
            let
                newLight =
                    Switch.toggle model.light
            in
            ( { model | light = newLight }
            , LocalStorage.save "light" <| Switch.encode newLight
            )

        LoadLight newLight ->
            ( { model | light = newLight }
            , Cmd.none
            )

        LogError errString ->
            ( Debug.log errString model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    LocalStorage.subscribe handleLocalStorageMsg


handleLocalStorageMsg : LocalStorage.Msg -> Msg
handleLocalStorageMsg lsm =
    case lsm of
        LocalStorage.OnLoad key value ->
            case key of
                "fileText" ->
                    value
                        |> attemptDecode Decode.string
                        |> Maybe.map FileTextRead
                        |> Maybe.withDefault DoNothing

                "light" ->
                    value
                        |> attemptDecode Switch.decoder
                        |> Maybe.map LoadLight
                        |> Maybe.withDefault DoNothing

                _ ->
                    Debug.log
                        ("Unknown Key: " ++ key)
                        DoNothing

        _ ->
            Debug.log
                "There was an error handling local storage msg."
                DoNothing


attemptDecode : Decoder a -> Value -> Maybe a
attemptDecode decoder value =
    case Decode.decodeValue decoder value of
        Ok decoded ->
            Just decoded

        Err err ->
            Debug.log (Decode.errorToString err)
                Nothing


view : Model -> Document Msg
view model =
    let
        { fileText, light } =
            model

        theme =
            ( Theme.light, Theme.dark )
                |> Switch.selectWith light
    in
    { title = "Elm App"
    , body =
        [ layout
            [ width fill
            , height fill
            , padding 16
            , Font.size 16
            , Fonts.bookInsanity
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
                    , el [ alignRight ] <| lightButton light
                    ]
                , selectFileButton theme
                , el [ Fonts.scalySans ]
                    (Util.viewFileText theme fileText)
                ]
        ]
    }


title : String -> Element msg
title string =
    el
        [ Region.heading 1
        , Font.size 32
        , Fonts.nodestoCapsCondensed
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
