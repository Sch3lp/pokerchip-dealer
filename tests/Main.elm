port module Main exposing (..)

import Tests
import Test exposing (concat)
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit <|
        Test.concat [ Tests.all ]


port emit : ( String, Value ) -> Cmd msg
