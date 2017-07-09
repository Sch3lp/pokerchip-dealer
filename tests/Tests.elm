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
        [ greedyTests
        ]



-- {color:'orange'			,amount:10	,denomination: 0.05	},// 22.22% -> 22 -> 25
-- 				{color:'white-red'		,amount:15	,denomination: 0.1	},// 33.33% -> 34 -> 35
-- 				{color:'red-blue'		,amount:12	,denomination: 0.25	},// 26.66% -> 27 -> 25
-- 				{color:'blue-white'		,amount:6	,denomination: 0.5	},// 13.33% -> 13 -> 10
-- 				{color:'green-pink'		,amount:2	,denomination: 1	} //  4.44% ->  4 ->  5


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


greedyTests : Test
greedyTests =
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
