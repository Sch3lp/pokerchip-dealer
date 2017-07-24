port module Main exposing (..)

import ScenarioTests
import UtilTests
import GreedyTests
import ModelTests
import DynamicProgrammingTests
import Test exposing (concat)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit <|
        Test.concat
            [ UtilTests.all
            , ModelTests.all
            , GreedyTests.all
            , DynamicProgrammingTests.all
            , ScenarioTests.all
            ]


port emit : ( String, Value ) -> Cmd msg
