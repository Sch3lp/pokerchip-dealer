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
        [ test "derp" <|
            \() -> Expect.equal True True
        ]
    ]
