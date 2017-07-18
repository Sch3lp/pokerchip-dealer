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


convertToDenomBaseTests : Test
convertToDenomBaseTests =
    describe "convertToDenomBase"
        [ test "should round" <|
            \() ->
                Expect.equal (convertToDenomBase 19.4) 1940
        ]
