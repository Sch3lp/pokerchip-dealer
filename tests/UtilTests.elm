module UtilTests exposing (..)

import Test exposing (..)
import Expect
import Util exposing (..)


all : Test
all =
    describe "Util"
        [ to3124Tests
        , hasAllSameTests
        ]


hasAllSameTests : Test
hasAllSameTests =
    describe "hasAllSame"
        [ test "Empty list returns true" <|
            \() ->
                Expect.equal (hasAllSame []) True
        , test "List with 1 item returns true" <|
            \() ->
                Expect.equal (hasAllSame [ 1 ]) True
        , test "List with 2 items, both same returns true" <|
            \() ->
                Expect.equal (hasAllSame [ 1, 1 ]) True
        , test "List with 2 items, both different returns false" <|
            \() ->
                Expect.equal (hasAllSame [ 1, 2 ]) False
        ]


to3124Tests : Test
to3124Tests =
    describe "to3214Order"
        [ test "Empty list returns empty list" <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3, 4, 5 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 3, 1, 2, 4, 5 ]
        , test "List with one element returns same list" <|
            \() ->
                let
                    someList =
                        [ 1 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 1 ]
        , test "List with two elements returns same list" <|
            \() ->
                let
                    someList =
                        [ 1, 2 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 1, 2 ]
        , test "List with exactly three elements returns 3 1 2" <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 3, 1, 2 ]
        , test "List with more than three elements returns three first" <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3, 4, 5 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 3, 1, 2, 4, 5 ]
        ]
