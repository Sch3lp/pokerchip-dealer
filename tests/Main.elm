port module Main exposing (..)

import ScenarioTests
import UtilTests
import GreedyTests
import Test exposing (concat)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit <|
        Test.concat [ ScenarioTests.all, GreedyTests.all, UtilTests.all ]


port emit : ( String, Value ) -> Cmd msg
