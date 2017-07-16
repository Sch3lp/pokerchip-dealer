module Tests exposing (..)

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
        [ test "10 euro for 1 player with exact amount in pokerset" <|
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
                        (greedySolve <| Model simplePokerset standardDenomValues 19.4 1)
                        [ ChipsInColorWithValue "purple" 1 5
                        , ChipsInColorWithValue "orange" 1 10
                        , ChipsInColorWithValue "white-red" 1 25
                        , ChipsInColorWithValue "red-blue" 1 50
                        , ChipsInColorWithValue "blue-white" 1 100
                        , ChipsInColorWithValue "green-pink" 1 250
                        , ChipsInColorWithValue "black-salmon" 1 500
                        , ChipsInColorWithValue "purple-pink" 1 1000
                        ]
        , test "10 euro for 2 players with exact amount in pokerset" <|
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
                        (greedySolve <| Model simplePokerset standardDenomValues 38.8 2)
                        [ ChipsInColorWithValue "purple" 1 5
                        , ChipsInColorWithValue "orange" 1 10
                        , ChipsInColorWithValue "white-red" 1 25
                        , ChipsInColorWithValue "red-blue" 1 50
                        , ChipsInColorWithValue "blue-white" 1 100
                        , ChipsInColorWithValue "green-pink" 1 250
                        , ChipsInColorWithValue "black-salmon" 1 500
                        , ChipsInColorWithValue "purple-pink" 1 1000
                        ]
        ]


pokerbrosCase : Test
pokerbrosCase =
    describe "Pokerbros case"
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
