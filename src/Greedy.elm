module Greedy exposing (..)

import Model exposing (..)


greedySolve : Model -> Stack
greedySolve model =
    [ ChipsInColorWithValue "green" 100 5 ]


assignPreferredDenominationValues : List Value -> PokerSet -> Stack
assignPreferredDenominationValues values pokerset =
    let
        sortedByAmount =
            List.sortBy .amount pokerset
    in
        [ ChipsInColorWithValue "green" 100 5 ]


limitAmount : Players -> PokerSet -> PokerSet
limitAmount players pokerset =
    List.map (limitAmountOfChips players) pokerset


limitAmountOfChips : Players -> ChipsInColor -> ChipsInColor
limitAmountOfChips players { color, amount } =
    let
        amountAsFloat =
            toFloat amount

        playersAsFloat =
            toFloat players

        newAmount =
            floor <| amountAsFloat / playersAsFloat
    in
        ChipsInColor color newAmount
