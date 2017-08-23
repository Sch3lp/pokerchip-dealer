module DynamicProgrammingTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)
import DP exposing (..)
import Debug exposing (..)


-- limited by players : limit total amounts of chips (of each color) by the amount of players
-- generate all possible combinations (not necessarily solutions) [DONE]
-- limited by buyin : only keep the real solutions (stackworth == buyin)
-- run an algorithm on those to retain the ideal solution:
-- 0.1 chips maxed, then .25, then .05, and that ideally have at least one from the first 5 denoms in the stack


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

                    permutations =
                        [ permWithValue100, lowerPerm, higherPerm ]

                    expected =
                        [ permWithValue100 ]
                in
                    Expect.equal
                        (limitByBuyin 100 permutations)
                        expected
        ]


limitByBuyin : Value -> List ValueStack -> List ValueStack
limitByBuyin buyin permutations =
    List.filter (\p -> valueStackWorth p == buyin) permutations



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
