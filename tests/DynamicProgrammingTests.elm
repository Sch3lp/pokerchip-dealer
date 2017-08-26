module DynamicProgrammingTests exposing (..)

import Test exposing (..)
import Expect
import Util exposing (..)
import Model exposing (..)
import DP exposing (..)
import Debug exposing (..)


-- limited by players : limit total amounts of chips (of each color) by the amount of players  [DONE]
-- generate all possible combinations (not necessarily solutions)                              [DONE]
-- limited by buyin : only keep the real solutions (stackworth == buyin)                       [DONE]
-- run an algorithm on those to retain the ideal solution:
-- 0.1 chips maxed, then .25, then .05 (the rest we don't care about)                          [DONE]
-- and that ideally have at least one from the first 5 denoms in the stack                     [DONE]


all : Test
all =
    describe "DP Unit Tests"
        dpUnitTests


dpUnitTests : List Test
dpUnitTests =
    [ describe "DP Unit Tests"
        [ multipleChipVariationsInChipsTests
        , findAllPermutationsTests
        , limitByBuyinTests
        , bestSolutionTests
        ]
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
                        [ [ { color = "purple", amount = 0, value = 5 }, { color = "purple", amount = 1, value = 5 }, { color = "purple", amount = 2, value = 5 } ]
                        , [ { color = "orange", amount = 0, value = 10 }, { color = "orange", amount = 1, value = 10 }, { color = "orange", amount = 2, value = 10 }, { color = "orange", amount = 3, value = 10 } ]
                        ]
        ]


findAllPermutationsTests : Test
findAllPermutationsTests =
    describe "findAllPermutations"
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
                        (findAllPermutations simple)
                        [ [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 0, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 0, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 0, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 0, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 0, value = 10 }, { color = "greene", amount = 0, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 1, value = 10 }, { color = "greene", amount = 0, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 3, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 2, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 1, value = 25 } ]
                        , [ { color = "purple", amount = 1, value = 5 }, { color = "orange", amount = 2, value = 10 }, { color = "greene", amount = 0, value = 25 } ]
                        ]
        -- , test "with pokerbros pokerset" <|
        --     \() ->
        --         let
        --             pokerbrospokerset =
        --                 [ { color = "purple", amount = 12, value = 5 }
        --                 , { color = "white-red", amount = 16, value = 10 }
        --                 , { color = "red-blue", amount = 16, value = 25 }
        --                 , { color = "orange", amount = 12, value = 50 }
        --                 , { color = "blue-white", amount = 8, value = 100 }
        --                 , { color = "green-pink", amount = 8, value = 250 }
        --                 , { color = "black-salmon", amount = 4, value = 500 }
        --                 , { color = "purple-pink", amount = 4, value = 1000 }
        --                 ]
        --         in
        --             Expect.equal
        --                 (List.isEmpty <| findAllPermutations pokerbrospokerset)
        --                 False
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
        [ describe "denom rules"
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
        , describe "different colors rule"
            [ test "prefer 5 different chip colors" <|
                \() ->
                    let
                        permWithExactly5DifferentColors =
                            [ { color = "purple", amount = 1, value = 5 }
                            , { color = "orange", amount = 1, value = 10 }
                            , { color = "greene", amount = 1, value = 25 }
                            , { color = "blueue", amount = 1, value = 50 }
                            , { color = "yellow", amount = 1, value = 100 }
                            ]

                        permWith3DifferentColors =
                            [ { color = "purple", amount = 1, value = 5 }
                            , { color = "orange", amount = 1, value = 10 }
                            , { color = "greene", amount = 1, value = 25 }
                            ]

                        permWith4DifferentColors =
                            [ { color = "purple", amount = 1, value = 5 }
                            , { color = "orange", amount = 1, value = 10 }
                            , { color = "greene", amount = 1, value = 25 }
                            , { color = "blueue", amount = 1, value = 50 }
                            ]

                        permWith6DifferentColors =
                            [ { color = "purple", amount = 1, value = 5 }
                            , { color = "orange", amount = 1, value = 10 }
                            , { color = "greene", amount = 1, value = 25 }
                            , { color = "blueue", amount = 1, value = 50 }
                            , { color = "yellow", amount = 1, value = 100 }
                            , { color = "reeeed", amount = 1, value = 250 }
                            ]

                        permWith7DifferentColors =
                            [ { color = "purple", amount = 1, value = 5 }
                            , { color = "orange", amount = 1, value = 10 }
                            , { color = "greene", amount = 1, value = 25 }
                            , { color = "blueue", amount = 1, value = 50 }
                            , { color = "yellow", amount = 1, value = 100 }
                            , { color = "reeeed", amount = 1, value = 250 }
                            , { color = "blaack", amount = 1, value = 500 }
                            ]

                        perms =
                            [ permWith4DifferentColors, permWith3DifferentColors, permWith7DifferentColors, permWithExactly5DifferentColors, permWith6DifferentColors ]
                    in
                        Expect.equal
                            (perms
                                |> colorVariation 5
                            )
                            [ permWithExactly5DifferentColors, permWith7DifferentColors, permWith6DifferentColors, permWith4DifferentColors, permWith3DifferentColors ]
            ]
        ]
