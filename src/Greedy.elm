module Greedy exposing (..)

import Model exposing (..)


greedySolve : Model -> Stack
greedySolve model =
    [ ( "green", 100, 5 ) ]


limitAmount : Players -> PokerSet -> PokerSet
limitAmount players pokerset =
    List.map (limitAmountOfChip players) pokerset


limitAmountOfChip : Players -> ChipsInColor -> ChipsInColor
limitAmountOfChip players ( color, amount ) =
    let
        amountAsFloat =
            toFloat amount

        playersAsFloat =
            toFloat players

        newAmount =
            floor <| amountAsFloat / playersAsFloat
    in
        ( color, newAmount )
