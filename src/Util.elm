module Util exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import File exposing (File)
import Theme exposing (Theme)
import Time exposing (posixToMillis)


viewFileMetaData : Theme -> Maybe File -> Element msg
viewFileMetaData theme maybeFile =
    case maybeFile of
        Just file ->
            row [ spacing 16 ]
                [ file
                    |> File.name
                    |> text
                , file
                    |> File.mime
                    |> text
                , file
                    |> File.size
                    |> String.fromInt
                    |> text
                , file
                    |> File.lastModified
                    |> posixToMillis
                    |> String.fromInt
                    |> text
                ]

        Nothing ->
            text "No File Selected..."


viewFileText : Theme -> Maybe String -> Element msg
viewFileText theme fileText =
    case fileText of
        Just string ->
            column [ width fill ] <|
                List.indexedMap (viewFileLine theme) <|
                    String.lines string

        Nothing ->
            text "No File Content..."


viewFileLine : Theme -> Int -> String -> Element msg
viewFileLine theme n line =
    paragraph
        [ Background.color <|
            if modBy 2 n == 0 then
                theme.evenRowTableBackground

            else
                theme.oddRowTableBackground
        ]
        [ el [ Font.color theme.dimTextColor ] <|
            text (String.fromInt n ++ ": ")
        , text line
        ]
