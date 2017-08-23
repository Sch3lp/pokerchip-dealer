module ModelTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)


all : Test
all =
    describe "Model Unit Tests"
        modelUnitTests


modelUnitTests : List Test
modelUnitTests =
    [ convertToDenomBaseTests ]


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


convertToDenomBaseTests : Test
convertToDenomBaseTests =
    describe "convertToDenomBase"
        [ test "should round" <|
            \() ->
                Expect.equal (convertToDenomBase 19.4) 1940
        , describe "limitAmount"
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
        ]
