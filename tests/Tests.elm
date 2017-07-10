module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Model exposing (..)
import Greedy exposing (..)


all : Test
all =
    describe "pokerchip dealer"
        [ greedyUnitTests

        --, scenarioTests
        ]


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


greedyUnitTests : Test
greedyUnitTests =
    describe "Greedy Unit Tests"
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
        , describe "to3214Order"
            [ test "Empty list returns empty list" <|
                \() ->
                    let
                        someList =
                            [ 1, 2, 3, 4, 5 ]
                    in
                        Expect.equal
                            (to3124 someList)
                            [ 3, 1, 2, 4, 5 ]
            , test "List with one element returns same list" <|
                \() ->
                    let
                        someList =
                            [ 1 ]
                    in
                        Expect.equal
                            (to3124 someList)
                            [ 1 ]
            , test "List with two elements returns same list" <|
                \() ->
                    let
                        someList =
                            [ 1, 2 ]
                    in
                        Expect.equal
                            (to3124 someList)
                            [ 1, 2 ]
            , test "List with exactly three elements returns 3 1 2" <|
                \() ->
                    let
                        someList =
                            [ 1, 2, 3 ]
                    in
                        Expect.equal
                            (to3124 someList)
                            [ 3, 1, 2 ]
            , test "List with more than three elements returns three first" <|
                \() ->
                    let
                        someList =
                            [ 1, 2, 3, 4, 5 ]
                    in
                        Expect.equal
                            (to3124 someList)
                            [ 3, 1, 2, 4, 5 ]
            ]
        , describe "assignPreferredDenominationValues"
            [ test "Highest amount is assigned big blind value, third highest small blind, second is third, fourth is fourth, ..." <|
                \() ->
                    Expect.equal
                        (assignPreferredDenominationValues standardDenomValues pokerbrosPokerset)
                        [ ChipsInColorWithValue "orange" 75 5
                        , ChipsInColorWithValue "white-red" 100 10
                        , ChipsInColorWithValue "red-blue" 100 25
                        , ChipsInColorWithValue "purple" 75 50
                        , ChipsInColorWithValue "blue-white" 50 100
                        , ChipsInColorWithValue "green-pink" 50 250
                        , ChipsInColorWithValue "black-salmon" 25 500
                        , ChipsInColorWithValue "purple-pink" 25 1000
                        ]
            ]
        ]


scenarioTests : Test
scenarioTests =
    describe "Greedy Algorithm"
        [ describe "Pokerbros case"
            [ test "10 euro for 6 players" <|
                \() ->
                    Expect.equal
                        (greedySolve <| Model pokerbrosPokerset standardDenomValues 10 6)
                        [ ChipsInColorWithValue "orange" 10 5
                        , ChipsInColorWithValue "white-red" 15 10
                        , ChipsInColorWithValue "red-blue" 12 25
                        , ChipsInColorWithValue "blue-white" 6 50
                        , ChipsInColorWithValue "green-pink" 2 100
                        ]
            ]
        ]



-- exampleTests : Test
-- exampleTests =
--     describe "Sample Test Suite"
--         [ describe "Unit test examples"
--             [ test "Addition" <|
--                 \() ->
--                     Expect.equal (3 + 7) 10
--             , test "String.left" <|
--                 \() ->
--                     Expect.equal "a" (String.left 1 "abcdefg")
--             ]
--         , describe "Fuzz test examples, using randomly generated input"
--             [ fuzz (list int) "Lists always have positive length" <|
--                 \aList ->
--                     List.length aList |> Expect.atLeast 0
--             , fuzz (list int) "Sorting a list does not change its length" <|
--                 \aList ->
--                     List.sort aList |> List.length |> Expect.equal (List.length aList)
--             , fuzzWith { runs = 1000 } int "List.member will get an integer in a list containing it" <|
--                 \i ->
--                     List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
--             , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
--                 \s1 s2 ->
--                     s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
--             ]
--         ]
