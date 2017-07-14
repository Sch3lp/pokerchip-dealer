module Greedy exposing (..)

import Model exposing (..)
import Util exposing (..)


type alias MaxStackValue =
    Float


greedySolve : Model -> Stack
greedySolve model =
    let
        stack =
            assignPreferredDenominationValues standardDenomValues <| sortedByAmountDesc model.pokerset

        limitedChips =
            limitChipsInStack model.players stack
    in
        limitedChips


limitChipsInStack : Players -> Stack -> Stack
limitChipsInStack players stack =
    List.map (divideAmountBy players) stack


divideAmountBy : Players -> (ChipsInColorWithValue -> ChipsInColorWithValue)
divideAmountBy players chips =
    let
        newAmount =
            floor <| (toFloat chips.amount / toFloat players)
    in
        { chips | amount = newAmount }


assignPreferredDenominationValues : List Value -> PokerSet -> Stack
assignPreferredDenominationValues values pokerset =
    let
        chipsIn3124Order =
            to3124WhenDifferentAmounts pokerset
    in
        List.map2 toChipsWithValue chipsIn3124Order values


to3124WhenDifferentAmounts : PokerSet -> PokerSet
to3124WhenDifferentAmounts pokerset =
    if hasAllSame (List.map .amount pokerset) then
        pokerset
    else
        to3124 <| sortedByAmountDesc pokerset


sortedByAmountDesc : PokerSet -> PokerSet
sortedByAmountDesc pokerset =
    sortWithDesc .amount <| pokerset


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
