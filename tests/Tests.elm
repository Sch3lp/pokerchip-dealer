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
    [ ( "purple", 75 )
    , ( "orange", 75 )
    , ( "white-red", 100 )
    , ( "red-blue", 100 )
    , ( "blue-white", 50 )
    , ( "green-pink", 50 )
    , ( "black-salmon", 25 )
    , ( "purple-pink", 25 )
    ]


greedyUnitTests : Test
greedyUnitTests =
    describe "Greedy Unit Tests"
        [ describe "Find limited amount of chips per color"
            [ test "for 6 players" <|
                \() ->
                    Expect.equal
                        (limitAmount 6 pokerbrosPokerset)
                        [ ( "purple", 12 )
                        , ( "orange", 12 )
                        , ( "white-red", 16 )
                        , ( "red-blue", 16 )
                        , ( "blue-white", 8 )
                        , ( "green-pink", 8 )
                        , ( "black-salmon", 4 )
                        , ( "purple-pink", 4 )
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
                        [ ( "orange", 10, 5 )
                        , ( "white-red", 15, 10 )
                        , ( "red-blue", 12, 25 )
                        , ( "blue-white", 6, 50 )
                        , ( "green-pink", 2, 100 )
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
