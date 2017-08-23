module Greedy exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)


type alias MaxStackValue =
    Float


greedySolve : Model -> Stack
greedySolve model =
    let
        limitedByPlayers =
            limitAmount model.players model.pokerset

        stack =
            assignPreferredDenominations standardDenoms <| limitedByPlayers

        data =
            greedyChange model.buyin <| to2314 stack

        stackIn2314Reversed =
            List.reverse <| to2314 stack

        greedyStack =
            List.map2 updateDenomAmount data.usedValues stackIn2314Reversed
    in
        stackSortedByDenomination greedyStack



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
