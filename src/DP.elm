module DP exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)
import Cartesian exposing (lazyCartesian)
import Lazy.List exposing (LazyList)


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
            Debug.log "limited stack" <| List.map chipsWithDenomToValue stack

        permutations =
            findAllPermutations valueStack

        idealAmountOfChipColors =
            5

        filteredPermutations =
            permutations
                |> lazyLimitByBuyin buyinValue
                |> lazyColorVariation idealAmountOfChipColors
                |> Lazy.List.toList

        bestPermutations =
            filteredPermutations
                |> maxAmount bigBlind
                |> maxAmount thirdDenom
                |> maxAmount smallBlind

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


findAllPermutations : ValueStack -> LazyList ValueStack
findAllPermutations chipses =
    lazyCartesian <| multipleChipVariationsInChips chipses


limitByBuyin : Value -> List ValueStack -> List ValueStack
limitByBuyin buyin permutations =
    List.filter (\p -> valueStackWorth p == buyin) permutations


lazyLimitByBuyin : Value -> LazyList ValueStack -> LazyList ValueStack
lazyLimitByBuyin buyin permutations =
    Lazy.List.keepIf (\p -> valueStackWorth p == buyin) permutations


lazyColorVariation : Int -> LazyList ValueStack -> LazyList ValueStack
lazyColorVariation preferredNbrVariations permutations =
    permutations
        |> Lazy.List.keepIf (\vs -> List.length vs == preferredNbrVariations)


colorVariation : Int -> List ValueStack -> List ValueStack
colorVariation preferredNbrVariations permutations =
    (\( a, b ) -> List.append a b)
        (permutations
            |> sortWithDesc List.length
            |> List.partition (\vs -> List.length vs == preferredNbrVariations)
        )
