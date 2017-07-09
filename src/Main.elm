module Main exposing (..)

import Html exposing (Html)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)


myPokerSet : PokerSet
myPokerSet =
    [ ( "purple", 75 )
    , ( "orange", 75 )
    , ( "white-red", 100 )
    , ( "red-blue", 100 )
    , ( "blue-white", 50 )
    , ( "green-pink", 50 )
    , ( "black-salmon", 25 )
    , ( "purple-pink", 25 )
    ]


initialModel : Model
initialModel =
    { pokerset = myPokerSet
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
