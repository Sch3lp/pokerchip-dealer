module ScenarioTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)
import Greedy exposing (..)


all : Test
all =
    describe "Pokerchip dealer Scenario Tests"
        [ simpleCase

        -- , pokerbrosCase
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
                    [ ChipsInColor "purple" 1
                    , ChipsInColor "orange" 1
                    , ChipsInColor "white-red" 1
                    , ChipsInColor "red-blue" 1
                    , ChipsInColor "blue-white" 1
                    , ChipsInColor "green-pink" 1
                    , ChipsInColor "black-salmon" 1
                    , ChipsInColor "purple-pink" 1
                    ]
            in
                Expect.equal
                    (greedySolve <| Model simplePokerset standardDenoms 19.4 1)
                    [ ChipsInColorWithDenom "purple" 1 0.05
                    , ChipsInColorWithDenom "orange" 1 0.1
                    , ChipsInColorWithDenom "white-red" 1 0.25
                    , ChipsInColorWithDenom "red-blue" 1 0.5
                    , ChipsInColorWithDenom "blue-white" 1 1
                    , ChipsInColorWithDenom "green-pink" 1 2.5
                    , ChipsInColorWithDenom "black-salmon" 1 5
                    , ChipsInColorWithDenom "purple-pink" 1 10
                    ]


with2Players : Test
with2Players =
    test "10 euro for 2 players with exact amount in pokerset" <|
        \() ->
            let
                simplePokerset =
                    [ ChipsInColor "purple" 2
                    , ChipsInColor "orange" 2
                    , ChipsInColor "white-red" 2
                    , ChipsInColor "red-blue" 2
                    , ChipsInColor "blue-white" 2
                    , ChipsInColor "green-pink" 2
                    , ChipsInColor "black-salmon" 2
                    , ChipsInColor "purple-pink" 2
                    ]
            in
                Expect.equal
                    (greedySolve <| Model simplePokerset standardDenoms 38.8 2)
                    [ ChipsInColorWithDenom "purple" 1 0.05
                    , ChipsInColorWithDenom "orange" 1 0.1
                    , ChipsInColorWithDenom "white-red" 1 0.25
                    , ChipsInColorWithDenom "red-blue" 1 0.5
                    , ChipsInColorWithDenom "blue-white" 1 1
                    , ChipsInColorWithDenom "green-pink" 1 2.5
                    , ChipsInColorWithDenom "black-salmon" 1 5
                    , ChipsInColorWithDenom "purple-pink" 1 10
                    ]


pokerbrosCase : Test
pokerbrosCase =
    describe "Pokerbros case"
        [ test "10 euro for 6 players" <|
            \() ->
                Expect.equal
                    (greedySolve <| Model pokerbrosPokerset standardDenoms 10 6)
                    [ ChipsInColorWithDenom "orange" 10 0.05
                    , ChipsInColorWithDenom "white-red" 15 0.1
                    , ChipsInColorWithDenom "red-blue" 12 0.25
                    , ChipsInColorWithDenom "blue-white" 6 0.5
                    , ChipsInColorWithDenom "green-pink" 2 1
                    ]
        ]
