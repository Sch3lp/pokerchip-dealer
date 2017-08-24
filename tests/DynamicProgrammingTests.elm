module DynamicProgrammingTests exposing (..)

import Test exposing (..)
import Expect
import Util exposing (..)
import Model exposing (..)
import DP exposing (..)
import Debug exposing (..)


-- limited by players : limit total amounts of chips (of each color) by the amount of players
-- generate all possible combinations (not necessarily solutions)                              [DONE]
-- limited by buyin : only keep the real solutions (stackworth == buyin)                       [DONE]
-- run an algorithm on those to retain the ideal solution:
-- 0.1 chips maxed, then .25, then .05 (the rest we don't care about)
-- and that ideally have at least one from the first 5 denoms in the stack


all : Test
all =
    describe "DP Unit Tests"
        dpUnitTests


dpUnitTests : List Test
dpUnitTests =
    [ describe "DP Unit Tests"
        [ chipColorVariationsTests
        , multipleChipVariationsInChipsTests
        , comboGenerationInChipsTests
        , limitByBuyinTests
        , bestSolutionTests
        ]
    ]


chipColorVariationsTests : Test
chipColorVariationsTests =
    describe "chipColorVariations"
        [ test "one denom with 4 chips has 4 combinations" <|
            \() ->
                let
                    simple =
                        { color = "orange", amount = 4, value = 10 }
                in
                    Expect.equal
                        (chipColorVariations simple { amountOfChipsUsed = 0, combos = [] })
                        { amountOfChipsUsed = 4, combos = [ 4, 3, 2, 1 ] }
        ]


multipleChipVariationsInChipsTests : Test
multipleChipVariationsInChipsTests =
    describe "multipleChipVariationsInChips"
        [ test "two denoms with 2 and 3 chips has 2 x 3 combinations" <|
            \() ->
                let
                    simple =
                        [ { color = "purple", amount = 2, value = 5 }
                        , { color = "orange", amount = 3, value = 10 }
                        ]
                in
                    Expect.equal
                        (multipleChipVariationsInChips simple)
                        [ [ { color = "purple", amount = 1, value = 5 }, { color = "purple", amount = 2, value = 5 } ]
                        , [ { color = "orange", amount = 1, value = 10 }, { color = "orange", amount = 2, value = 10 }, { color = "orange", amount = 3, value = 10 } ]
                        ]
        ]


comboGenerationInChipsTests : Test
comboGenerationInChipsTests =
    describe "comboGenerationInChips"
        [ test "cartesian product of all amount ranges of the different chips" <|
            \() ->
                let
                    simple =
                        [ { color = "purple", amount = 1, value = 5 }
                        , { color = "orange", amount = 2, value = 10 }
                        , { color = "greene", amount = 3, value = 25 }
                        ]
                in
                    Expect.equal
                        (comboGenerationInChips simple)
                        [ [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        ]
        ]


limitByBuyinTests : Test
limitByBuyinTests =
    describe "limitByBuyin"
        [ test "should only retain permutations of which the stackworth equals the buyin" <|
            \() ->
                let
                    permWithValue100 =
                        [ { color = "purple", amount = 4, value = 5 }
                        , { color = "orange", amount = 3, value = 10 }
                        , { color = "greene", amount = 2, value = 25 }
                        ]

                    lowerPerm =
                        [ { color = "purple", amount = 3, value = 5 }
                        , { color = "orange", amount = 3, value = 10 }
                        , { color = "greene", amount = 2, value = 25 }
                        ]

                    higherPerm =
                        [ { color = "purple", amount = 4, value = 5 }
                        , { color = "orange", amount = 3, value = 10 }
                        , { color = "greene", amount = 3, value = 25 }
                        ]

                    perms =
                        [ permWithValue100, lowerPerm, higherPerm ]

                    expected =
                        [ permWithValue100 ]
                in
                    Expect.equal
                        (limitByBuyin 100 perms)
                        expected
        ]


bestSolutionTests : Test
bestSolutionTests =
    describe "bestSolution"
        [ describe "max BigBlinds"
            [ test "should prefer ValueStacks that have highest amount of big blinds" <|
                \() ->
                    let
                        permWithMostBigBlinds =
                            [ { color = "purple", amount = 4, value = 5 }
                            , { color = "orange", amount = 10, value = 10 }
                            , { color = "greene", amount = 2, value = 25 }
                            ]

                        permWithSecondMostBigBlinds =
                            [ { color = "purple", amount = 3, value = 5 }
                            , { color = "orange", amount = 5, value = 10 }
                            , { color = "greene", amount = 2, value = 25 }
                            ]

                        permWithLeastBigBlinds =
                            [ { color = "purple", amount = 4, value = 5 }
                            , { color = "orange", amount = 3, value = 10 }
                            , { color = "greene", amount = 3, value = 25 }
                            ]

                        perms =
                            [ permWithSecondMostBigBlinds, permWithLeastBigBlinds, permWithMostBigBlinds ]
                    in
                        Expect.equal
                            (maxAmount bigBlind perms)
                            [ permWithMostBigBlinds, permWithSecondMostBigBlinds, permWithLeastBigBlinds ]
            ]
        , describe "max SmallBlinds"
            [ test "should prefer ValueStacks that have highest amount of small blinds" <|
                \() ->
                    let
                        permWithMostSmallBlinds =
                            [ { color = "purple", amount = 10, value = 5 }
                            , { color = "orange", amount = 4, value = 10 }
                            , { color = "greene", amount = 2, value = 25 }
                            ]

                        permWithSecondMostSmallBlinds =
                            [ { color = "purple", amount = 5, value = 5 }
                            , { color = "orange", amount = 3, value = 10 }
                            , { color = "greene", amount = 2, value = 25 }
                            ]

                        permWithLeastSmallBlinds =
                            [ { color = "purple", amount = 3, value = 5 }
                            , { color = "orange", amount = 4, value = 10 }
                            , { color = "greene", amount = 3, value = 25 }
                            ]

                        perms =
                            [ permWithSecondMostSmallBlinds, permWithLeastSmallBlinds, permWithMostSmallBlinds ]
                    in
                        Expect.equal
                            (maxAmount smallBlind perms)
                            [ permWithMostSmallBlinds, permWithSecondMostSmallBlinds, permWithLeastSmallBlinds ]
            ]
        , describe "max 3rd denoms"
            [ test "should prefer ValueStacks that have highest amount of 3rd denominations" <|
                \() ->
                    let
                        permWithMost3rdDenoms =
                            [ { color = "purple", amount = 2, value = 5 }
                            , { color = "orange", amount = 4, value = 10 }
                            , { color = "greene", amount = 10, value = 25 }
                            ]

                        permWithSecondMost3rdDenoms =
                            [ { color = "purple", amount = 2, value = 5 }
                            , { color = "orange", amount = 3, value = 10 }
                            , { color = "greene", amount = 5, value = 25 }
                            ]

                        permWithLeast3rdDenoms =
                            [ { color = "purple", amount = 3, value = 5 }
                            , { color = "orange", amount = 4, value = 10 }
                            , { color = "greene", amount = 3, value = 25 }
                            ]

                        perms =
                            [ permWithSecondMost3rdDenoms, permWithLeast3rdDenoms, permWithMost3rdDenoms ]
                    in
                        Expect.equal
                            (maxAmount thirdDenom perms)
                            [ permWithMost3rdDenoms, permWithSecondMost3rdDenoms, permWithLeast3rdDenoms ]
            ]
        , test "should prefer ValueStacks that first have highest big blinds, then highest 3rd denoms, then highest small blinds" <|
            \() ->
                let
                    {- same bb and 3rd denom amount, but higher small blind -}
                    perfectPerm =
                        [ { color = "purple", amount = 10, value = 5 }
                        , { color = "orange", amount = 10, value = 10 }
                        , { color = "greene", amount = 10, value = 25 }
                        , { color = "blueue", amount = 2, value = 50 }
                        ]

                    {- same 3rd denom amount, but higher small blind -}
                    secondBestPerm =
                        [ { color = "purple", amount = 10, value = 5 }
                        , { color = "orange", amount = 10, value = 10 }
                        , { color = "greene", amount = 9, value = 25 }
                        , { color = "blueue", amount = 2, value = 50 }
                        ]

                    {- same sb amount, but higher 3rd denom -}
                    thirdBestPerm =
                        [ { color = "purple", amount = 9, value = 5 }
                        , { color = "orange", amount = 10, value = 10 }
                        , { color = "greene", amount = 9, value = 25 }
                        , { color = "blueue", amount = 2, value = 50 }
                        ]

                    {- same sb and 3rd denom amount, but higher bb -}
                    fourthBestPerm =
                        [ { color = "purple", amount = 9, value = 5 }
                        , { color = "orange", amount = 10, value = 10 }
                        , { color = "greene", amount = 8, value = 25 }
                        , { color = "blueue", amount = 2, value = 50 }
                        ]

                    lastBestPerm =
                        [ { color = "purple", amount = 9, value = 5 }
                        , { color = "orange", amount = 9, value = 10 }
                        , { color = "greene", amount = 8, value = 25 }
                        , { color = "blueue", amount = 2, value = 50 }
                        ]

                    perms =
                        [ secondBestPerm, lastBestPerm, thirdBestPerm, perfectPerm, fourthBestPerm ]
                in
                    Expect.equal
                        (perms
                            |> maxAmount bigBlind
                            |> maxAmount thirdDenom
                            |> maxAmount smallBlind
                        )
                        [ perfectPerm, secondBestPerm, thirdBestPerm, fourthBestPerm, lastBestPerm ]
        ]


{-| Using a chipExtractor that singles out 1 ChipsInColorWithValue, order a ValueStack according to the amount. For example:

    maxAmount (\valueStack -> Maybe.withDefault { amount = 0, color = "blank", value = 0 } <| List.head <| valueStack) stack

-}
maxAmount : (ValueStack -> ChipsInColorWithValue) -> List ValueStack -> List ValueStack
maxAmount chipExtractor permutations =
    sortWithDesc (\vs -> .amount (chipExtractor vs)) permutations


{-| Extracts the ChipsInColorWithValue that's supposedly the Small Blind.
The assumption is that the ValueStack's denominations are in order from low to high, with the lowest being the small blind.
Another assumption is that the ValueStack is not empty.
-}
smallBlind : ValueStack -> ChipsInColorWithValue
smallBlind valueStack =
    Maybe.withDefault { amount = 0, color = "blank", value = 0 } <| List.head <| valueStack


{-| Extracts the ChipsInColorWithValue that's supposedly the Big Blind.
The assumption is that the ValueStack's denominations are in order from low to high, with the lowest being the small blind
Another assumption is that the ValueStack is not empty.
-}
bigBlind : ValueStack -> ChipsInColorWithValue
bigBlind valueStack =
    Maybe.withDefault { amount = 0, color = "blank", value = 0 } <| List.head <| to2314 valueStack


{-| Extracts the ChipsInColorWithValue that's supposedly the third denomination (0.05 0.1 0.25 ..., so 0.25).
The assumption is that the ValueStack's denominations are in order from low to high, with the lowest being the small blind
Another assumption is that the ValueStack is not empty.
-}
thirdDenom : ValueStack -> ChipsInColorWithValue
thirdDenom valueStack =
    Maybe.withDefault { amount = 0, color = "blank", value = 0 } <| List.head <| to3214 valueStack



-- generateCombinationsTests : Test
-- generateCombinationsTests =
--     describe "generateCombinations"
--         [ test "one denom with 4 chips has 4 combinations" <|
--             \() ->
--                 let
--                     simple =
--                         [ { color = "orange", amount = 4, denom = 0.1 } ]
--                 in
--                     Expect.equal
--                         (generateCombinations 0.4 simple)
--                         { toDistribute = 30, usedValues = [ 1 ], innerData = { amountOfChipsUsed = 1 } }
--         , test "recursion" <|
--             \() ->
--                 let
--                     simple =
--                         [ { color = "orange", amount = 4, denom = 0.1 } ]
--                 in
--                     Expect.equal
--                         (generateComboRecursively simple <| InnerData 0)
--                         [ { toDistribute = 30, usedValues = [ 1 ], innerData = { amountOfChipsUsed = 1 } }
--                         , { toDistribute = 20, usedValues = [ 2 ], innerData = { amountOfChipsUsed = 2 } }
--                         , { toDistribute = 10, usedValues = [ 3 ], innerData = { amountOfChipsUsed = 3 } }
--                         , { toDistribute = 0, usedValues = [ 4 ], innerData = { amountOfChipsUsed = 4 } }
--                         ]
--         ]
