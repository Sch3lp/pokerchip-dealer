module Main exposing (..)

import Html exposing (Html)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)


myPokerSet : PokerSet
myPokerSet =
    [ ChipsInColor "purple" 75
    , ChipsInColor "orange" 75
    , ChipsInColor "white-red" 100
    , ChipsInColor "red-blue" 100
    , ChipsInColor "blue-white" 50
    , ChipsInColor "green-pink" 50
    , ChipsInColor "black-salmon" 25
    , ChipsInColor "purple-pink" 25
    ]


initialModel : Model
initialModel =
    { pokerset = myPokerSet
    , denoms = standardDenoms
    , buyin = 10
    , players = 6
    }


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \model -> Sub.none
        }
