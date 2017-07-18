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
            assignPreferredDenominations standardDenoms model.pokerset

        data =
            greedyChange model.buyin <| to2314 stack

        stackIn2314Reversed =
            List.reverse <| to2314 stack

        greedyStack =
            List.map2 combineDenoms data.usedValues stackIn2314Reversed
    in
        List.reverse greedyStack



-- prep


assignPreferredDenominations : List Denomination -> PokerSet -> Stack
assignPreferredDenominations denoms pokerset =
    let
        denomsSortedAsc =
            List.sort denoms

        chipsIn3124Order =
            to3124WhenDifferentAmounts <| sortedByAmountDesc pokerset
    in
        List.map2 toChipsWithDenomination chipsIn3124Order denomsSortedAsc


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
            convertToDenomBase buyin

        convertedStack =
            List.map chipsWithDenomToValue stack

        initialData =
            Data toDistribute []
    in
        List.foldl makeChangeForDenom initialData convertedStack


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


limitAmount : Players -> PokerSet -> PokerSet
limitAmount players pokerset =
    List.map (limitAmountOfChips players) pokerset


limitAmountOfChips : Players -> ChipsInColor -> ChipsInColor
limitAmountOfChips players { color, amount } =
    ChipsInColor color (amount // players)


limitChipsByPlayers : Players -> Stack -> Stack
limitChipsByPlayers players stack =
    List.map (divideAmountBy players) stack


divideAmountBy : Players -> ChipsInColorWithDenom -> ChipsInColorWithDenom
divideAmountBy players chips =
    { chips | amount = chips.amount // players }


combineDenoms : Amount -> ChipsInColorWithDenom -> ChipsInColorWithDenom
combineDenoms amount chips =
    { chips | amount = amount }
