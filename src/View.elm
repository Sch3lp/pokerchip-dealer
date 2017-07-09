module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html.Html Msg
view model =
    div [] [ text <| (++) "Your PokerSet contains: " <| String.join ", " <| pokersetToString model.pokerset ]
