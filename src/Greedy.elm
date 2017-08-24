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
