module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)


view : Model -> Html.Html Msg
view model =
    let
        greedySolve =
            solve model
    in
        div []
            [ div [] [ text "Your PokerSet contains: " ]
            , div [] <| pokersetToDivs model.pokerset
            , Html.br [] []
            , div [] [ text <| "You seem to want above chips to be divided over " ++ (toString model.players) ++ " players" ++ " for a buyin of " ++ (toString model.buyin) ++ " moodollars" ]
            , Html.br [] []
            , div [] [ text "The ideal stack I came up with is:" ]
            , Html.br [] []
            , div [] <| stackToDivs <| greedySolve
            , Html.br [] []
            , div [] [ text <| "Which is worth a total of " ++ (toString <| stackWorth greedySolve) ++ " moodollars." ]
            ]


pokersetToDivs : PokerSet -> List (Html Msg)
pokersetToDivs pokerset =
    List.map chipsInColorToDiv pokerset


chipsInColorToDiv : ChipsInColor -> Html Msg
chipsInColorToDiv chips =
    div [] [ text <| chipsInColorToString chips ]


stackToDivs : Stack -> List (Html Msg)
stackToDivs stack =
    List.map chipsInColorWithDenomToDiv stack


chipsInColorWithDenomToDiv : ChipsInColorWithDenom -> Html msg
chipsInColorWithDenomToDiv chips =
    div [] [ text <| chipsInColorWithDenomToString chips ]
