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
        , div [] <| stackToDivs model.pokerset
        , Html.br [] []
        , div [] [ text <| "You seem to want above chips to be divided over " ++ (toString model.players) ++ " players" ++ " for a buyin of " ++ (toString model.buyin) ++ " eurodollars" ]
        , Html.br [] []
        , div [] [ text "The ideal solution I came up with is:" ]
        , Html.br [] []
        , div [] <| stackToDivs <| solve model
        ]


stackToDivs : Stack -> List (Html Msg)
stackToDivs stack =
    List.map chipsInColorToDiv stack


chipsInColorToDiv : ChipsInColor -> Html Msg
chipsInColorToDiv chips =
    div [] [ text <| chipsInColorToString chips ]
