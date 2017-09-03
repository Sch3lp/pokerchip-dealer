module CartesianTests exposing (..)

import Cartesian exposing (..)
import Lazy.List exposing (LazyList)
import Test exposing (..)
import Expect


cartesianRecursiveTests : Test
cartesianRecursiveTests =
    describe "cartesianRecursive"
        [ test "cartesian with two lists" <|
            \() ->
                Expect.equal
                    (Lazy.List.toList <| lazyCartesian [ [ 1, 2 ], [ 3, 4 ] ])
                    [ [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ] ]
        , test "cartesian with two lists, different amount" <|
            \() ->
                Expect.equal
                    (Lazy.List.toList <| lazyCartesian [ [ 1, 2 ], [ 3, 4, 5 ] ])
                    [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 3 ], [ 2, 4 ], [ 2, 5 ] ]
        , test "cartesian with single element lists" <|
            \() ->
                Expect.equal
                    (Lazy.List.toList <| lazyCartesian [ [ 1 ], [ 2 ], [ 3 ] ])
                    [ [ 1, 2, 3 ] ]
        , test "cartesian with same amount of list elements" <|
            \() ->
                Expect.equal
                    (Lazy.List.toList <| lazyCartesian [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ])
                    [ [ 1, 3, 5 ], [ 1, 3, 6 ], [ 1, 4, 5 ], [ 1, 4, 6 ], [ 2, 3, 5 ], [ 2, 3, 6 ], [ 2, 4, 5 ], [ 2, 4, 6 ] ]
        , test "cartesian with different amount of list elements" <|
            \() ->
                Expect.equal
                    (Lazy.List.toList <| lazyCartesian [ [ 1, 2 ], [ 3, 4, 5 ], [ 6, 7 ] ])
                    [ [ 1, 3, 6 ], [ 1, 3, 7 ], [ 1, 4, 6 ], [ 1, 4, 7 ], [ 1, 5, 6 ], [ 1, 5, 7 ], [ 2, 3, 6 ], [ 2, 3, 7 ], [ 2, 4, 6 ], [ 2, 4, 7 ], [ 2, 5, 6 ], [ 2, 5, 7 ] ]
        , test "cartesian with pokerbros amounts" <|
            \() ->
                let
                    pokerbrosAmounts =
                        [ List.range 0 12
                        , List.range 0 16
                        , List.range 0 16
                        , List.range 0 12
                        , List.range 0 8
                        , List.range 0 8
                        , List.range 0 4
                        , List.range 0 4
                        ]
                in
                    Expect.equal
                        (Lazy.List.isEmpty (lazyCartesian pokerbrosAmounts))
                        False
        ]


cartesianHelperTests : Test
cartesianHelperTests =
    describe "cartesianHelper - explaining cartesian [[1,2],[3,4],[5,6],[7,8]]"
        {- loop the first list [1,2] ([[1],[2]]) and apply cartesian with the next list [3,4] -}
        [ test "step 0.1 of helper" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1 ] [ 3, 4 ])
                    [ [ 1, 4 ], [ 1, 3 ] ]
        , test "step 0.2 of helper" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2 ] [ 3, 4 ])
                    [ [ 2, 4 ], [ 2, 3 ] ]

        {- combine the results into a list of lists and loop it [[1,3],[1,4],[2,3],[2,4]] and apply cartesian with the next list [5,6] -}
        , test "step 1.1 of helper (cartesianToList was applied to first pair)" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 3 ] [ 5, 6 ])
                    [ [ 1, 3, 6 ], [ 1, 3, 5 ] ]
        , test "step 1.2" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 4 ] [ 5, 6 ])
                    [ [ 1, 4, 6 ], [ 1, 4, 5 ] ]
        , test "step 1.3" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 3 ] [ 5, 6 ])
                    [ [ 2, 3, 6 ], [ 2, 3, 5 ] ]
        , test "step 1.4" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4 ] [ 5, 6 ])
                    [ [ 2, 4, 6 ], [ 2, 4, 5 ] ]

        {- loop the result list [[1,3,5],[1,3,6],[1,4,5],[1,4,6],[2,3,5],[2,3,6],[2,4,5],[2,4,6]] and apply cartesian with the next list [7,8] -}
        , test "step 2.1 now we can append the previous results with the [7,8]" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 3, 5 ] [ 7, 8 ])
                    [ [ 1, 3, 5, 8 ], [ 1, 3, 5, 7 ] ]
        , test "step 2.2" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 3, 6 ] [ 7, 8 ])
                    [ [ 1, 3, 6, 8 ], [ 1, 3, 6, 7 ] ]
        , test "step 2.3" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 4, 5 ] [ 7, 8 ])
                    [ [ 1, 4, 5, 8 ], [ 1, 4, 5, 7 ] ]
        , test "step 2.4" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 4, 6 ] [ 7, 8 ])
                    [ [ 1, 4, 6, 8 ], [ 1, 4, 6, 7 ] ]
        , test "step 2.5" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 3, 5 ] [ 7, 8 ])
                    [ [ 2, 3, 5, 8 ], [ 2, 3, 5, 7 ] ]
        , test "step 2.6" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4, 6 ] [ 7, 8 ])
                    [ [ 2, 4, 6, 8 ], [ 2, 4, 6, 7 ] ]
        , test "step 2.7" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4, 5 ] [ 7, 8 ])
                    [ [ 2, 4, 5, 8 ], [ 2, 4, 5, 7 ] ]
        , test "step 2.8" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4, 6 ] [ 7, 8 ])
                    [ [ 2, 4, 6, 8 ], [ 2, 4, 6, 7 ] ]
        ]
