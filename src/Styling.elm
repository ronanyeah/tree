module Styling exposing (..)

import Color exposing (Color, black, rgb)
import Style exposing (Property, StyleSheet, hover, style, styleSheet)
import Style.Background as Bg
import Style.Border as Border
import Style.Font as Font
import Style.Color as Color
import Types exposing (Styles(..))


styling : StyleSheet Styles vs
styling =
    styleSheet
        [ style None []
        , style SetBox
            [ Border.all 2
            , Border.solid
            ]
        , style Button
            [ Border.rounded 15
            , pointer
            , Color.background b
            ]
        , style Body
            [ Font.typeface
                [ Font.font "Cuprum"
                , Font.sansSerif
                ]
            , Font.size 25
            , Color.background c
            ]
        , style Icon
            [ Color.text e
            , Border.rounded 15
            , pointer
            , hover [ Color.text a ]
            ]
        , style Link [ Font.underline, pointer ]
        , style Line [ Color.background e ]
        , style Header
            [ Font.size 40
            , Color.text e
            , pointer
            , hover [ Color.text a ]
            ]
        , style Title [ Color.text e ]
        ]


pointer : Property class variation
pointer =
    Style.cursor "pointer"


a : Color
a =
    rgb 195 106 104


b : Color
b =
    rgb 108 109 104


c : Color
c =
    rgb 182 55 48


d : Color
d =
    rgb 217 56 49


e : Color
e =
    rgb 231 191 122
