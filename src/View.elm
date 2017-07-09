module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html.Html Msg
view model =
    div []
        [ div [] [ text "Your PokerSet contains: " ]
        , div [] <| pokersetToDivs model.pokerset
        ]


pokersetToDivs : PokerSet -> List (Html Msg)
pokersetToDivs pokerset =
    List.map chipsInColorToDiv pokerset


chipsInColorToDiv : ChipsInColor -> Html Msg
chipsInColorToDiv chips =
    div [] [ text <| chipsInColorToString chips ]
