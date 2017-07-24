module DP exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)


dpSolve : Model -> Stack
dpSolve model =
    []


type alias Data =
    { toDistribute : Int, usedValues : List Amount, innerData : InnerData }


type alias InnerData =
    { amountOfChipsUsed : Amount }


generateCombinations : Buyin -> Stack -> Data
generateCombinations buyin stack =
    let
        toDistribute =
            convertToDenomBase buyin

        convertedStack =
            List.map chipsWithDenomToValue stack

        initialData =
            Data toDistribute [] <| InnerData 0
    in
        List.foldl generateComboRecursively initialData convertedStack


generateComboRecursively : ChipsInColorWithValue -> Data -> Data
generateComboRecursively chips data =
    let
        newInnerData =
            { amountOfChipsUsed = data.innerData.amountOfChipsUsed + 1 }
    in
        if (data.innerData.amountOfChipsUsed == chips.amount) then
            data
        else
            generateComboRecursively chips { data | innerData = newInnerData }


type alias ChipsUsedAccumulator =
    { amountOfChipsUsed : Amount, combos : List Amount }


chipColorVariations : ChipsInColorWithValue -> ChipsUsedAccumulator -> ChipsUsedAccumulator
chipColorVariations chips acc =
    if acc.amountOfChipsUsed == chips.amount then
        acc
    else
        let
            newAmount =
                acc.amountOfChipsUsed + 1

            newCombos =
                newAmount :: acc.combos
        in
            chipColorVariations chips { acc | combos = newCombos, amountOfChipsUsed = newAmount }
