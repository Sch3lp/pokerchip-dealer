module Greedy exposing (..)

import Model exposing (..)


greedySolve : Model -> Stack
greedySolve model =
    [ ChipsInColorWithValue "green" 100 5 ]


assignPreferredDenominationValues : List Value -> PokerSet -> Stack
assignPreferredDenominationValues values pokerset =
    let
        chipsIn3124Order =
            to3124 <| sortedByAmountDesc pokerset
    in
        List.map2 toChipsWithValue chipsIn3124Order values


byAmountDesc : ChipsInColor -> ChipsInColor -> Order
byAmountDesc a b =
    case compare a.amount b.amount of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


sortedByAmountDesc : PokerSet -> PokerSet
sortedByAmountDesc pokerset =
    List.sortWith byAmountDesc pokerset


to3124 : List a -> List a
to3124 list =
    case list of
        one :: two :: three :: t ->
            three :: one :: two :: t

        list ->
            list


toChipsWithValue : ChipsInColor -> Value -> ChipsInColorWithValue
toChipsWithValue { color, amount } value =
    ChipsInColorWithValue color amount value


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