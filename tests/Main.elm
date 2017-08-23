port module Main exposing (..)

import UtilTests
import CartesianTests
import ModelTests
import GreedyTests
import DynamicProgrammingTests
import ScenarioTests
import Test exposing (concat)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit <|
        Test.concat
            [ UtilTests.all
            , CartesianTests.all
            , ModelTests.all
            , GreedyTests.all
            , DynamicProgrammingTests.all
            , ScenarioTests.all
            ]


port emit : ( String, Value ) -> Cmd msg
