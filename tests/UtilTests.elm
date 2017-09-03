module UtilTests exposing (..)

import Test exposing (..)
import Expect
import Util exposing (..)


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
    describe "to3124Order"
        [ test "Empty list returns empty list" <|
            \() ->
                Expect.equal (to3124 []) []
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
        , test "List with exactly three elements returns 3 2 1" <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 3, 1, 2 ]
        , test "List with more than three elements returns 3 1 2 4 5 ..." <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3, 4, 5 ]
                in
                    Expect.equal
                        (to3124 someList)
                        [ 3, 1, 2, 4, 5 ]
        ]


to3214Tests : Test
to3214Tests =
    describe "to3214Order"
        [ test "Empty list returns empty list" <|
            \() ->
                Expect.equal (to3214 []) []
        , test "List with one element returns same list" <|
            \() ->
                let
                    someList =
                        [ 1 ]
                in
                    Expect.equal
                        (to3214 someList)
                        [ 1 ]
        , test "List with two elements returns same list" <|
            \() ->
                let
                    someList =
                        [ 1, 2 ]
                in
                    Expect.equal
                        (to3214 someList)
                        [ 1, 2 ]
        , test "List with exactly three elements returns 3 2 1" <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3 ]
                in
                    Expect.equal
                        (to3214 someList)
                        [ 3, 2, 1 ]
        , test "List with more than three elements returns 3 2 1 4 5 ..." <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3, 4, 5 ]
                in
                    Expect.equal
                        (to3214 someList)
                        [ 3, 2, 1, 4, 5 ]
        ]


to2314Tests : Test
to2314Tests =
    describe "to2314Order"
        [ test "Empty list returns empty list" <|
            \() ->
                Expect.equal (to2314 []) []
        , test "List with one element returns same list" <|
            \() ->
                let
                    someList =
                        [ 1 ]
                in
                    Expect.equal
                        (to2314 someList)
                        [ 1 ]
        , test "List with two elements returns same list" <|
            \() ->
                let
                    someList =
                        [ 1, 2 ]
                in
                    Expect.equal
                        (to2314 someList)
                        [ 1, 2 ]
        , test "List with exactly three elements returns 2 3 1" <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3 ]
                in
                    Expect.equal
                        (to2314 someList)
                        [ 2, 3, 1 ]
        , test "List with more than three elements returns 2 3 1 4 5 ..." <|
            \() ->
                let
                    someList =
                        [ 1, 2, 3, 4, 5 ]
                in
                    Expect.equal
                        (to2314 someList)
                        [ 2, 3, 1, 4, 5 ]
        ]
