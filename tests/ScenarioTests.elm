module ScenarioTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)
import Greedy exposing (..)
import DP exposing (dpSolve)


pokerbrosPokerset : PokerSet
pokerbrosPokerset =
    -- [ { color = "purple", amount = 75 }
    [ { color = "orange", amount = 75 }
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


simpleCase : Test
simpleCase =
    describe "Simple case"
        [ with1Player
        , with2Players
        ]


with1Player : Test
with1Player =
    test "10 euro for 1 player with exact amount in pokerset" <|
        \() ->
            let
                simplePokerset =
                    [ { color = "purple", amount = 1 }
                    , { color = "orange", amount = 1 }
                    , { color = "white-red", amount = 1 }
                    , { color = "red-blue", amount = 1 }
                    , { color = "blue-white", amount = 1 }
                    , { color = "green-pink", amount = 1 }
                    , { color = "black-salmon", amount = 1 }
                    , { color = "purple-pink", amount = 1 }
                    ]
            in
                Expect.equal
                    (greedySolve <| Model simplePokerset standardDenoms 19.4 1)
                    [ { color = "purple", amount = 1, denom = 0.05 }
                    , { color = "orange", amount = 1, denom = 0.1 }
                    , { color = "white-red", amount = 1, denom = 0.25 }
                    , { color = "red-blue", amount = 1, denom = 0.5 }
                    , { color = "blue-white", amount = 1, denom = 1 }
                    , { color = "green-pink", amount = 1, denom = 2.5 }
                    , { color = "black-salmon", amount = 1, denom = 5 }
                    , { color = "purple-pink", amount = 1, denom = 10 }
                    ]


with2Players : Test
with2Players =
    test "10 euro for 2 players with exact amount in pokerset" <|
        \() ->
            let
                simplePokerset =
                    [ { color = "purple", amount = 2 }
                    , { color = "orange", amount = 2 }
                    , { color = "white-red", amount = 2 }
                    , { color = "red-blue", amount = 2 }
                    , { color = "blue-white", amount = 2 }
                    , { color = "green-pink", amount = 2 }
                    , { color = "black-salmon", amount = 2 }
                    , { color = "purple-pink", amount = 2 }
                    ]
            in
                Expect.equal
                    (greedySolve <| Model simplePokerset standardDenoms 38.8 2)
                    [ { color = "purple", amount = 1, denom = 0.05 }
                    , { color = "orange", amount = 1, denom = 0.1 }
                    , { color = "white-red", amount = 1, denom = 0.25 }
                    , { color = "red-blue", amount = 1, denom = 0.5 }
                    , { color = "blue-white", amount = 1, denom = 1 }
                    , { color = "green-pink", amount = 1, denom = 2.5 }
                    , { color = "black-salmon", amount = 1, denom = 5 }
                    , { color = "purple-pink", amount = 1, denom = 10 }
                    ]


pokerbrosCase : Test
pokerbrosCase =
    describe "Pokerbros case"
        [ Test.skip <|
            test "10 euro for 6 players" <|
                \() ->
                    Expect.equal
                        (greedySolve <| Model pokerbrosPokerset standardDenoms 10 6)
                        [ { color = "orange", amount = 10, denom = 0.05 }
                        , { color = "white-red", amount = 15, denom = 0.1 }
                        , { color = "red-blue", amount = 12, denom = 0.25 }
                        , { color = "blue-white", amount = 6, denom = 0.5 }
                        , { color = "green-pink", amount = 2, denom = 1 }
                        ]
        ]


pokerbrosCaseDP : Test
pokerbrosCaseDP =
    describe "Pokerbros case with Dynamic Programming solve"
        [ test "10 euro for 6 players" <|
            \() ->
                Expect.equal
                    (dpSolve <| Model pokerbrosPokerset standardDenoms 10 6)
                    [ { color = "orange", amount = 10, denom = 0.05 }
                    , { color = "white-red", amount = 15, denom = 0.1 }
                    , { color = "red-blue", amount = 12, denom = 0.25 }
                    , { color = "blue-white", amount = 6, denom = 0.5 }
                    , { color = "green-pink", amount = 2, denom = 1 }
                    ]
        ]
