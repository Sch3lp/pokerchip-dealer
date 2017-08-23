module DP exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)
import Cartesian exposing (cartesianRecursive)


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


multipleChipVariations : List ChipsInColorWithValue -> List (List Amount)
multipleChipVariations chipses =
    List.map (\chips -> List.range 1 chips.amount) chipses


comboGeneration : List ChipsInColorWithValue -> List (List Amount)
comboGeneration chipses =
    cartesianRecursive <| multipleChipVariations chipses


multipleChipVariationsInChips : List ChipsInColorWithValue -> List (List ChipsInColorWithValue)
multipleChipVariationsInChips chipses =
    let
        minAmountOfChips =
            1
    in
        List.map
            (\chips ->
                List.range minAmountOfChips chips.amount
                    |> List.map (\a -> { chips | amount = a })
            )
            chipses


comboGenerationInChips : List ChipsInColorWithValue -> List (List ChipsInColorWithValue)
comboGenerationInChips chipses =
    cartesianRecursive <| multipleChipVariationsInChips chipses
