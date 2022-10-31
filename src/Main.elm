module Main exposing (main)

import Browser exposing (Document)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Colors exposing (..)
import Element.Font as Font
import Element.Input as Input exposing (button)
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
    { file : Maybe File
    , fileText : Maybe String
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
    ( { file = Nothing
      , fileText = Nothing
      , light = Switch.Off
      , loaded = Encode.int 0
      }
    , Cmd.batch
        [ LocalStorage.save "test" <| Encode.int 3
        , LocalStorage.load "test"
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
            ( { model | file = Just file }
            , Task.perform FileTextRead <| File.toString file
            )

        FileTextRead fileText ->
            ( { model | fileText = Just fileText }
            , Cmd.none
            )

        ToggleLight ->
            ( { model | light = Switch.toggle model.light }
            , Cmd.none
            )

        TestLoaded value ->
            ( { model | loaded = value }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    LocalStorage.subscribe
        (\lsm ->
            case lsm of
                LocalStorage.OnLoad _ value ->
                    TestLoaded value

                _ ->
                    DoNothing
        )


view : Model -> Document Msg
view model =
    let
        theme =
            ( Theme.light, Theme.dark )
                |> Switch.selectWith model.light

        { file, fileText } =
            model
    in
    { title = "Elm App"
    , body =
        [ layout
            [ width fill
            , height fill
            , padding 16
            , Font.family [ Font.monospace ]
            , Background.color theme.background
            , Font.color theme.textColor
            ]
          <|
            column [ spacing 16, width fill ]
                [ row
                    [ spacing 16
                    , width fill
                    ]
                    [ selectFileButton theme
                    , Util.viewFileMetaData theme file
                    , el [ alignRight ] <| lightButton model.light
                    ]
                , text <| Encode.encode 0 model.loaded
                , Util.viewFileText theme fileText
                ]
        ]
    }


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
