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
    [ ChipsInColor "purple" 75
    , ChipsInColor "orange" 75
    , ChipsInColor "white-red" 100
    , ChipsInColor "red-blue" 100
    , ChipsInColor "blue-white" 50
    , ChipsInColor "green-pink" 50
    , ChipsInColor "black-salmon" 25
    , ChipsInColor "purple-pink" 25
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
                    [ ChipsInColor "purple" 12
                    , ChipsInColor "orange" 12
                    , ChipsInColor "white-red" 16
                    , ChipsInColor "red-blue" 16
                    , ChipsInColor "blue-white" 8
                    , ChipsInColor "green-pink" 8
                    , ChipsInColor "black-salmon" 4
                    , ChipsInColor "purple-pink" 4
                    ]
        ]
    , describe "sortedByAmountDesc"
        [ test "returns pokerset sortedByAmount Desc" <|
            \() ->
                Expect.equal
                    (sortedByAmountDesc noPurplePokerset)
                    [ ChipsInColor "white-red" 100
                    , ChipsInColor "red-blue" 100
                    , ChipsInColor "orange" 75
                    , ChipsInColor "blue-white" 50
                    , ChipsInColor "green-pink" 50
                    , ChipsInColor "black-salmon" 25
                    , ChipsInColor "purple-pink" 25
                    ]
        ]
    , describe "assignPreferredDenominationValues"
        [ test "Highest amount is assigned big blind value, third highest small blind, second is third, fourth is fourth, ..." <|
            \() ->
                Expect.equal
                    (assignPreferredDenominations standardDenoms noPurplePokerset)
                    [ ChipsInColorWithDenom "orange" 75 0.05
                    , ChipsInColorWithDenom "white-red" 100 0.1
                    , ChipsInColorWithDenom "red-blue" 100 0.25
                    , ChipsInColorWithDenom "blue-white" 50 0.5
                    , ChipsInColorWithDenom "green-pink" 50 1
                    , ChipsInColorWithDenom "black-salmon" 25 2.5
                    , ChipsInColorWithDenom "purple-pink" 25 5
                    ]
        , test "to2314 with ordered by amount desc" <|
            \() ->
                let
                    input =
                        [ ChipsInColor "white-red" 100
                        , ChipsInColor "red-blue" 80
                        , ChipsInColor "orange" 75
                        , ChipsInColor "blue-white" 50
                        ]
                in
                    Expect.equal
                        (to3124 input)
                        [ ChipsInColor "orange" 75
                        , ChipsInColor "white-red" 100
                        , ChipsInColor "red-blue" 80
                        , ChipsInColor "blue-white" 50
                        ]
        , test "to3124WhenDifferentAmounts" <|
            \() ->
                let
                    input =
                        [ ChipsInColor "orange" 75
                        , ChipsInColor "white-red" 100
                        , ChipsInColor "red-blue" 80
                        , ChipsInColor "blue-white" 50
                        ]
                in
                    Expect.equal
                        (to3124WhenDifferentAmounts input)
                        [ ChipsInColor "orange" 75
                        , ChipsInColor "white-red" 100
                        , ChipsInColor "red-blue" 80
                        , ChipsInColor "blue-white" 50
                        ]
        , test "to3124WhenDifferentAmounts first three amounts are the same, order remains for those but changes for the rest" <|
            \() ->
                let
                    input =
                        [ ChipsInColor "orange" 100
                        , ChipsInColor "white-red" 100
                        , ChipsInColor "red-blue" 100
                        , ChipsInColor "blue-white" 50
                        , ChipsInColor "green-pink" 75
                        ]
                in
                    Expect.equal
                        (to3124WhenDifferentAmounts input)
                        [ ChipsInColor "orange" 100
                        , ChipsInColor "white-red" 100
                        , ChipsInColor "red-blue" 100
                        , ChipsInColor "green-pink" 75
                        , ChipsInColor "blue-white" 50
                        ]
        ]
    , describe "limitChipsByPlayers"
        [ test "2 players, divisable amount" <|
            \() ->
                Expect.equal
                    (limitChipsByPlayers 2 [ ChipsInColorWithDenom "purple" 50 0.05, ChipsInColorWithDenom "white-red" 20 0.1 ])
                    [ ChipsInColorWithDenom "purple" 25 0.05
                    , ChipsInColorWithDenom "white-red" 10 0.1
                    ]
        , test "2 players, non divisable amount, is rounded down" <|
            \() ->
                Expect.equal
                    (limitChipsByPlayers 2 [ ChipsInColorWithDenom "purple" 49 0.05, ChipsInColorWithDenom "white-red" 33 0.1 ])
                    [ ChipsInColorWithDenom "purple" 24 0.05
                    , ChipsInColorWithDenom "white-red" 16 0.1
                    ]
        ]
    , describe "greedyChange"
        [ test "enough chips available" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ ChipsInColorWithDenom "purple" 100 0.1 ])
                    { toDistribute = 0, usedValues = [ 100 ] }
        , test "not enough chips available" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ ChipsInColorWithDenom "purple" 50 0.1 ])
                    { toDistribute = 500, usedValues = [ 50 ] }
        , test "no chips available" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ ChipsInColorWithDenom "purple" 0 0.1 ])
                    { toDistribute = 1000, usedValues = [ 0 ] }
        , test "multiple denoms with exactly available amount" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ ChipsInColorWithDenom "purple" 100 0.05, ChipsInColorWithDenom "orange" 50 0.1 ])
                    { toDistribute = 0, usedValues = [ 50, 100 ] }
        , test "multiple denoms with not enough available amount" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ ChipsInColorWithDenom "purple" 100 0.05, ChipsInColorWithDenom "orange" 49 0.1 ])
                    { toDistribute = 10, usedValues = [ 49, 100 ] }
        , test "multiple denoms with excess amount" <|
            \() ->
                Expect.equal
                    (greedyChange 10 [ ChipsInColorWithDenom "purple" 100 0.05, ChipsInColorWithDenom "orange" 51 0.1 ])
                    { toDistribute = 0, usedValues = [ 50, 100 ] }
        , test "simple pokerset with 1 of each color, to matched amount" <|
            \() ->
                let
                    simplePokerSet =
                        [ ChipsInColorWithDenom "orange" 1 0.1
                        , ChipsInColorWithDenom "white-red" 1 0.25
                        , ChipsInColorWithDenom "purple" 1 0.05
                        , ChipsInColorWithDenom "red-blue" 1 0.5
                        , ChipsInColorWithDenom "blue-white" 1 1
                        , ChipsInColorWithDenom "green-pink" 1 2.5
                        , ChipsInColorWithDenom "black-salmon" 1 5
                        , ChipsInColorWithDenom "purple-pink" 1 10
                        ]
                in
                    Expect.equal
                        (greedyChange 19.4 simplePokerSet)
                        { toDistribute = 0, usedValues = [ 1, 1, 1, 1, 1, 1, 1, 1 ] }
        ]
    ]
