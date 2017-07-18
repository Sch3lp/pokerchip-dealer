module Greedy exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)


type alias MaxStackValue =
    Float


greedySolve : Model -> Stack
greedySolve model =
    let
        stack =
            assignPreferredDenominationValues standardDenomValues model.pokerset

        data =
            Debug.log "data" <| greedyChange model.buyin <| to2314 stack

        stackIn3124Reversed =
            List.reverse <| to2314 stack

        greedyStack =
            List.map2 combineDenoms data.usedValues stackIn3124Reversed
    in
        List.reverse greedyStack



-- prep


assignPreferredDenominationValues : List Value -> PokerSet -> Stack
assignPreferredDenominationValues values pokerset =
    let
        valuesSortedAsc =
            List.sort values

        chipsIn3124Order =
            to3124WhenDifferentAmounts <| sortedByAmountDesc pokerset
    in
        List.map2 toChipsWithValue chipsIn3124Order valuesSortedAsc


to3124WhenDifferentAmounts : PokerSet -> PokerSet
to3124WhenDifferentAmounts pokerset =
    if hasAllSame <| List.map .amount <| pokerset then
        pokerset
    else if hasAllSame <| List.take 3 <| List.map .amount pokerset then
        List.append (List.take 3 pokerset) (sortedByAmountDesc <| List.drop 3 pokerset)
    else
        to3124 <| sortedByAmountDesc pokerset



-- greedy solve


type alias Data =
    { toDistribute : Int, usedValues : List Value }


greedyChange : Buyin -> Stack -> Data
greedyChange buyin stack =
    let
        toDistribute =
            floor (buyin * 100)

        -- TODO: preferred order is ok, but makeChange doesn't take into account available chips
        -- denomsToUse =
        --     Debug.log "using denoms" denomValues
        initialData =
            Data toDistribute []
    in
        List.foldl makeChangeForDenom initialData stack


makeChangeForDenom : ChipsInColorWithValue -> Data -> Data
makeChangeForDenom chips data =
    let
        availableChips =
            chips.amount

        valuesToUse =
            data.toDistribute // chips.value

        ( remaining, usedValues ) =
            if (valuesToUse < availableChips) then
                ( data.toDistribute % chips.value, valuesToUse )
            else
                ( data.toDistribute - (chipsValue chips), chips.amount )
    in
        { data
            | toDistribute =
                remaining
            , usedValues =
                usedValues :: data.usedValues
        }



-- Util


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
    ChipsInColor color (amount // players)


limitChipsByPlayers : Players -> Stack -> Stack
limitChipsByPlayers players stack =
    List.map (divideAmountBy players) stack


divideAmountBy : Players -> ChipsInColorWithValue -> ChipsInColorWithValue
divideAmountBy players chips =
    let
        newAmount =
            floor <| (toFloat chips.amount / toFloat players)
    in
        { chips | amount = newAmount }


combineDenoms : Value -> ChipsInColorWithValue -> ChipsInColorWithValue
combineDenoms value chipsInColorWithValue =
    { chipsInColorWithValue | amount = value }
