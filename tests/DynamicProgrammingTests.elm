module DynamicProgrammingTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)
import DP exposing (..)


-- generate all possible combinations (not necessarily solutions)
-- by just making stacks by adding 1 chip every time (end when all chips, limited by players, have been used)
-- only keep the real solutions (stackworth == buyin)
-- run an algorithm on those to retain the ideal solution:
-- 0.1 chips maxed, then .25, then .05, and that ideally have at least one from the first 5 denoms in the stack


all : Test
all =
    describe "DP Unit Tests"
        dpUnitTests


dpUnitTests : List Test
dpUnitTests =
    [ describe "DP Unit Tests"
        [ generateCombinationsTests
        ]
    ]


generateCombinationsTests : Test
generateCombinationsTests =
    describe "generateCombinations"
        [ test "one denom with 4 chips has 4 combinations" <|
            \() ->
                let
                    simple =
                        [ { color = "orange", amount = 4, denom = 0.1 } ]
                in
                    Expect.equal
                        (generateCombinations 0.4 simple)
                        { toDistribute = 30, usedValues = [ 1 ], innerData = { amountOfChipsUsed = 1 } }
        , test "recursion" <|
            \() ->
                let
                    simple =
                        [ { color = "orange", amount = 4, denom = 0.1 } ]
                in
                    Expect.equal
                        (generateComboRecursively simple <| InnerData 0)
                        [ { toDistribute = 30, usedValues = [ 1 ], innerData = { amountOfChipsUsed = 1 } }
                        , { toDistribute = 20, usedValues = [ 2 ], innerData = { amountOfChipsUsed = 2 } }
                        , { toDistribute = 10, usedValues = [ 3 ], innerData = { amountOfChipsUsed = 3 } }
                        , { toDistribute = 0, usedValues = [ 4 ], innerData = { amountOfChipsUsed = 4 } }
                        ]
        ]
