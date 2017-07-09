module Main exposing (..)

import Html exposing (Html)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)


initialModel : Model
initialModel =
    { text = "cunts" }


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \model -> Sub.none
        }
