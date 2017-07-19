module GreedyTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)
import Greedy exposing (..)
import Util exposing (..)


all : Test
all =
    describe "Greedy Unit Tests"
        greedyUnitTests


pokerbrosPokerset : PokerSet
pokerbrosPokerset =
    [ { color = "purple", amount = 75 }
    , { color = "orange", amount = 75 }
    , { color = "white-red", amount = 100 }
    , { color = "red-blue", amount = 100 }
    , { color = "blue-white", amount = 50 }
    , { color = "green-pink", amount = 50 }
    , { color = "black-salmon", amount = 25 }
    , { color = "purple-pink", amount = 25 }
    ]


noPurplePokerset : PokerSet
noPurplePokerset =
    List.drop 1 pokerbrosPokerset


greedyUnitTests : List Test
greedyUnitTests =
    [ describe "limitAmount"
        [ test "Find limited amount of chips per color for 6 players" <|
            \() ->
                Expect.equal
                    (limitAmount 6 pokerbrosPokerset)
                    [ { color = "purple", amount = 12 }
                    , { color = "orange", amount = 12 }
                    , { color = "white-red", amount = 16 }
                    , { color = "red-blue", amount = 16 }
                    , { color = "blue-white", amount = 8 }
                    , { color = "green-pink", amount = 8 }
                    , { color = "black-salmon", amount = 4 }
                    , { color = "purple-pink", amount = 4 }
                    ]
        ]
    , describe "sortedByAmountDesc"
        [ test "returns pokerset sortedByAmount Desc" <|
            \() ->
                Expect.equal
                    (sortedByAmountDesc noPurplePokerset)
                    [ { color = "white-red", amount = 100 }
                    , { color = "red-blue", amount = 100 }
                    , { color = "orange", amount = 75 }
                    , { color = "blue-white", amount = 50 }
                    , { color = "green-pink", amount = 50 }
                    , { color = "black-salmon", amount = 25 }
                    , { color = "purple-pink", amount = 25 }
                    ]
        ]
    , describe "assignPreferredDenominationValues"
        [ test "Highest amount is assigned big blind value, third highest small blind, second is third, fourth is fourth, ..." <|
            \() ->
                Expect.equal
                    (assignPreferredDenominations standardDenoms noPurplePokerset)
                    [ { color = "orange", amount = 75, denom = 0.05 }
                    , { color = "white-red", amount = 100, denom = 0.1 }
                    , { color = "red-blue", amount = 100, denom = 0.25 }
                    , { color = "blue-white", amount = 50, denom = 0.5 }
                    , { color = "green-pink", amount = 50, denom = 1 }
                    , { color = "black-salmon", amount = 25, denom = 2.5 }
                    , { color = "purple-pink", amount = 25, denom = 5 }
                    ]
        , test "to2314 with ordered by amount desc" <|
            \() ->
                let
                    input =
                        [ { color = "white-red", amount = 100 }
                        , { color = "red-blue", amount = 80 }
                        , { color = "orange", amount = 75 }
                        , { color = "blue-white", amount = 50 }
                        ]
                in
                    Expect.equal
                        (to3124 input)
                        [ { color = "orange", amount = 75 }
                        , { color = "white-red", amount = 100 }
                        , { color = "red-blue", amount = 80 }
                        , { color = "blue-white", amount = 50 }
                        ]
        , test "to3124WhenDifferentAmounts" <|
            \() ->
                let
                    input =
                        [ { color = "orange", amount = 75 }
                        , { color = "white-red", amount = 100 }
                        , { color = "red-blue", amount = 80 }
                        , { color = "blue-white", amount = 50 }
                        ]
                in
                    Expect.equal
                        (to3124WhenDifferentAmounts input)
                        [ { color = "orange", amount = 75 }
                        , { color = "white-red", amount = 100 }
                        , { color = "red-blue", amount = 80 }
                        , { color = "blue-white", amount = 50 }
                        ]
        , test "to3124WhenDifferentAmounts first three amounts are the same, order remains for those but changes for the rest" <|
            \() ->
                let
                    input =
                        [ { color = "orange", amount = 100 }
                        , { color = "white-red", amount = 100 }
                        , { color = "red-blue", amount = 100 }
                        , { color = "blue-white", amount = 50 }
                        , { color = "green-pink", amount = 75 }
                        ]
                in
                    Expect.equal
                        (to3124WhenDifferentAmounts input)
                        [ { color = "orange", amount = 100 }
                        , { color = "white-red", amount = 100 }
                        , { color = "red-blue", amount = 100 }
                        , { color = "green-pink", amount = 75 }
                        , { color = "blue-white", amount = 50 }
                        ]
        ]
    , describe "greedyChange"
        [ test "enough chips available" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ { color = "purple", amount = 100, denom = 0.1 } ])
                    { toDistribute = 0, usedValues = [ 100 ] }
        , test "not enough chips available" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ { color = "purple", amount = 50, denom = 0.1 } ])
                    { toDistribute = 500, usedValues = [ 50 ] }
        , test "no chips available" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ { color = "purple", amount = 0, denom = 0.1 } ])
                    { toDistribute = 1000, usedValues = [ 0 ] }
        , test "multiple denoms with exactly available amount" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ { color = "purple", amount = 100, denom = 0.05 }, { color = "orange", amount = 50, denom = 0.1 } ])
                    { toDistribute = 0, usedValues = [ 50, 100 ] }
        , test "multiple denoms with not enough available amount" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ { color = "purple", amount = 100, denom = 0.05 }, { color = "orange", amount = 49, denom = 0.1 } ])
                    { toDistribute = 10, usedValues = [ 49, 100 ] }
        , test "multiple denoms with excess amount" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ { color = "purple", amount = 100, denom = 0.05 }, { color = "orange", amount = 51, denom = 0.1 } ])
                    { toDistribute = 0, usedValues = [ 50, 100 ] }
        , test "simple pokerset with 1 of each color, to matched amount" <|
            \() ->
                let
                    simplePokerSet =
                        [ { color = "orange", amount = 1, denom = 0.1 }
                        , { color = "white-red", amount = 1, denom = 0.25 }
                        , { color = "purple", amount = 1, denom = 0.05 }
                        , { color = "red-blue", amount = 1, denom = 0.5 }
                        , { color = "blue-white", amount = 1, denom = 1 }
                        , { color = "green-pink", amount = 1, denom = 2.5 }
                        , { color = "black-salmon", amount = 1, denom = 5 }
                        , { color = "purple-pink", amount = 1, denom = 10 }
                        ]
                in
                    Expect.equal
                        (greedyChange 19.4 simplePokerSet)
                        { toDistribute = 0, usedValues = [ 1, 1, 1, 1, 1, 1, 1, 1 ] }
        , test "pokerbros limited" <|
            \() ->
                let
                    pokerbro =
                        [ { color = "orange", amount = 16, denom = 0.1 }
                        , { color = "white-red", amount = 16, denom = 0.25 }
                        , { color = "purple", amount = 12, denom = 0.05 }
                        , { color = "red-blue", amount = 12, denom = 0.5 }
                        , { color = "blue-white", amount = 8, denom = 1 }
                        , { color = "green-pink", amount = 8, denom = 2.5 }
                        , { color = "black-salmon", amount = 4, denom = 5 }
                        , { color = "purple-pink", amount = 4, denom = 10 }
                        ]
                in
                    Expect.equal
                        (greedyChange 10 pokerbro)
                        { toDistribute = 30, usedValues = [ 0, 0, 0, 0, 7, 12, 16, 16 ] }
        ]

    -- TODO write fuzzy tests that given 10 euro should return 10 euro worth of chips
    ]
