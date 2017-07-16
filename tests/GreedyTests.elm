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
        [ test "to2314 with ordered by amount desc" <|
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
        , test "Highest amount is assigned big blind value, third highest small blind, second is third, fourth is fourth, ..." <|
            \() ->
                Expect.equal
                    (assignPreferredDenominationValues standardDenomValues noPurplePokerset)
                    [ ChipsInColorWithValue "orange" 75 5
                    , ChipsInColorWithValue "white-red" 100 10
                    , ChipsInColorWithValue "red-blue" 100 25
                    , ChipsInColorWithValue "blue-white" 50 50
                    , ChipsInColorWithValue "green-pink" 50 100
                    , ChipsInColorWithValue "black-salmon" 25 250
                    , ChipsInColorWithValue "purple-pink" 25 500
                    ]
        ]
    , describe "limitChipsByPlayers"
        [ test "2 players, divisable amount" <|
            \() ->
                Expect.equal
                    (limitChipsByPlayers 2 [ ChipsInColorWithValue "purple" 50 5, ChipsInColorWithValue "white-red" 20 10 ])
                    [ ChipsInColorWithValue "purple" 25 5
                    , ChipsInColorWithValue "white-red" 10 10
                    ]
        , test "2 players, non divisable amount, is rounded down" <|
            \() ->
                Expect.equal
                    (limitChipsByPlayers 2 [ ChipsInColorWithValue "purple" 49 5, ChipsInColorWithValue "white-red" 33 10 ])
                    [ ChipsInColorWithValue "purple" 24 5
                    , ChipsInColorWithValue "white-red" 16 10
                    ]
        ]
    ]
