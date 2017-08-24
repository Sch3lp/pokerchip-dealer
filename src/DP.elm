module DP exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)
import Cartesian exposing (cartesianRecursive)


dpSolve : Model -> Stack
dpSolve model =
    let
        limitedByPlayers =
            limitAmount model.players model.pokerset

        stack =
            assignPreferredDenominations standardDenoms <| limitedByPlayers
    in
        solve model.buyin stack


solve : Buyin -> Stack -> Stack
solve buyin stack =
    let
        buyinValue : ValueStackWorth
        buyinValue =
            convertToDenomBase buyin

        valueStack =
            List.map chipsWithDenomToValue stack

        permutations =
            comboGenerationInChips valueStack

        bestPermutations =
            permutations
                |> limitByBuyin buyinValue
                |> maxAmount bigBlind
                |> maxAmount thirdDenom
                |> maxAmount smallBlind
                |> colorVariation 5

        bestPerm =
            Maybe.withDefault [ { amount = 0, color = "blank", value = 0 } ] <| List.head bestPermutations
    in
        List.map chipsWithValueToDenom bestPerm


multipleChipVariationsInChips : ValueStack -> List ValueStack
multipleChipVariationsInChips chipses =
    let
        minAmountOfChips =
            0
    in
        List.map
            (\chips ->
                List.range minAmountOfChips chips.amount
                    |> List.map (\a -> { chips | amount = a })
            )
            chipses


comboGenerationInChips : ValueStack -> List ValueStack
comboGenerationInChips chipses =
    cartesianRecursive <| multipleChipVariationsInChips chipses


limitByBuyin : Value -> List ValueStack -> List ValueStack
limitByBuyin buyin permutations =
    List.filter (\p -> valueStackWorth p == buyin) permutations


colorVariation : Int -> List ValueStack -> List ValueStack
colorVariation preferredVariations permutations =
    (\( a, b ) -> List.append a b)
        (permutations
            |> sortWithDesc List.length
            |> List.partition (\vs -> List.length vs == 5)
        )
