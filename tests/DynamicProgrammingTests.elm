module DynamicProgrammingTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (..)
import DP exposing (..)


-- generate all possible combinations (not necessarily solutions)
-- by just making stacks by adding 1 chip every time (end when all chips, limited by players, have been used)
-- only keep the real solutions (stackworth == buyin)
-- run an algorithm on those to retain the ideal solution:
-- 0.1 chips maxed, then .25, then .05, and that ideally have at least one from the first 5 denoms in the stack


all : Test
all =
    describe "DP Unit Tests"
        dpUnitTests


dpUnitTests : List Test
dpUnitTests =
    [ describe "DP Unit Tests"
        [ chipColorVariationsTests
        , multipleChipVariationsTests
        , cartesianTests
        ]
    ]


cartesianTests : Test
cartesianTests =
    describe "cartesian tests"
        [ cartesianTupleTests
        , cartesianListTests
        , cartesianRecursiveTests
        , cartesianHelperTests
        ]


chipColorVariationsTests : Test
chipColorVariationsTests =
    describe "chipColorVariations"
        [ test "one denom with 4 chips has 4 combinations" <|
            \() ->
                let
                    simple =
                        { color = "orange", amount = 4, value = 10 }
                in
                    Expect.equal
                        (chipColorVariations simple { amountOfChipsUsed = 0, combos = [] })
                        { amountOfChipsUsed = 4, combos = [ 4, 3, 2, 1 ] }
        ]


multipleChipVariationsTests : Test
multipleChipVariationsTests =
    describe "multipleChipVariations"
        [ test "two denoms with 2 chips has 2 x 2 combinations" <|
            \() ->
                let
                    simple =
                        [ { color = "purple", amount = 2, value = 5 }
                        , { color = "orange", amount = 3, value = 10 }
                        ]
                in
                    Expect.equal
                        (multipleChipVariations simple)
                        [ [ 1, 2 ], [ 1, 2, 3 ] ]
        ]


cartesianTupleTests : Test
cartesianTupleTests =
    describe "cartesian"
        [ test "cartesian with single elements" <|
            \() ->
                Expect.equal
                    (cartesian [ 1, 2 ] [ 1 ])
                    [ ( 1, 1 ), ( 2, 1 ) ]
        , test "cartesian with multiple elements" <|
            \() ->
                Expect.equal
                    (cartesian [ 1, 2 ] [ 1, 2, 3 ])
                    [ ( 1, 1 ), ( 1, 2 ), ( 1, 3 ), ( 2, 1 ), ( 2, 2 ), ( 2, 3 ) ]
        ]


cartesianListTests : Test
cartesianListTests =
    describe "cartesian"
        [ test "cartesian with single elements" <|
            \() ->
                Expect.equal
                    (cartesianToList [ 1, 2 ] [ 1 ])
                    [ [ 1, 1 ], [ 2, 1 ] ]
        , test "cartesian with multiple elements" <|
            \() ->
                Expect.equal
                    (cartesianToList [ 1, 2 ] [ 1, 2, 3 ])
                    [ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ] ]
        ]


cartesianRecursiveTests : Test
cartesianRecursiveTests =
    describe "cartesianRecursive"
        [ test "cartesian with two lists" <|
            \() ->
                Expect.equal
                    (cartesianRecursive [ [ 1, 2 ], [ 3, 4 ] ])
                    [ [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 2, 4 ] ]
        , test "cartesian with two lists, different amount" <|
            \() ->
                Expect.equal
                    (cartesianRecursive [ [ 1, 2 ], [ 3, 4, 5 ] ])
                    [ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], [ 2, 3 ], [ 2, 4 ], [ 2, 5 ] ]
        , test "cartesian with single element lists" <|
            \() ->
                Expect.equal
                    (cartesianRecursive [ [ 1 ], [ 2 ], [ 3 ] ])
                    [ [ 1, 2, 3 ] ]
        , test "cartesian with same amount of list elements" <|
            \() ->
                Expect.equal
                    (cartesianRecursive [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ])
                    [ [ 1, 3, 5 ], [ 1, 3, 6 ], [ 1, 4, 5 ], [ 1, 4, 6 ], [ 2, 3, 5 ], [ 2, 3, 6 ], [ 2, 4, 5 ], [ 2, 4, 6 ] ]
        , test "cartesian with different amount of list elements" <|
            \() ->
                Expect.equal
                    (cartesianRecursive [ [ 1, 2 ], [ 3, 4, 5 ], [ 6, 7 ] ])
                    [ [ 1, 3, 6 ]
                    , [ 1, 3, 7 ]
                    , [ 1, 4, 6 ]
                    , [ 1, 4, 7 ]
                    , [ 1, 5, 6 ]
                    , [ 1, 5, 7 ]
                    , [ 2, 3, 6 ]
                    , [ 2, 3, 7 ]
                    , [ 2, 4, 6 ]
                    , [ 2, 4, 7 ]
                    , [ 2, 5, 6 ]
                    , [ 2, 5, 7 ]
                    ]
        ]


cartesian : List a -> List a -> List ( a, a )
cartesian xs ys =
    List.concatMap
        (\x -> List.map (\y -> ( x, y )) ys)
        xs


cartesianToList : List a -> List a -> List (List a)
cartesianToList xs ys =
    List.concatMap (\x -> List.map (\y -> x :: [ y ]) ys) xs


cartesianRecursive : List (List a) -> List (List a)
cartesianRecursive lists =
    case lists of
        [] ->
            []

        one :: [] ->
            [ one ]

        h :: t ->
            let
                acc =
                    List.map (\x -> [ x ]) h
            in
                List.foldl reduceWithCartesian acc t


reduceWithCartesian : List a -> List (List a) -> List (List a)
reduceWithCartesian otherList acc =
    let
        loop temp =
            case temp of
                [] ->
                    []

                h :: t ->
                    (cartesianHelper h otherList) ++ loop t
    in
        loop acc


cartesianHelperTests : Test
cartesianHelperTests =
    describe "cartesianHelper - explaining cartesian [[1,2],[3,4],[5,6],[7,8]]"
        {- loop the first list [1,2] ([[1],[2]]) and apply cartesian with the next list [3,4] -}
        [ test "step 0.1 of helper" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1 ] [ 3, 4 ])
                    [ [ 1, 3 ], [ 1, 4 ] ]
        , test "step 0.2 of helper" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2 ] [ 3, 4 ])
                    [ [ 2, 3 ], [ 2, 4 ] ]

        {- combine the results into a list of lists and loop it [[1,3],[1,4],[2,3],[2,4]] and apply cartesian with the next list [5,6] -}
        , test "step 1.1 of helper (cartesianToList was applied to first pair)" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 3 ] [ 5, 6 ])
                    [ [ 1, 3, 5 ], [ 1, 3, 6 ] ]
        , test "step 1.2" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 4 ] [ 5, 6 ])
                    [ [ 1, 4, 5 ], [ 1, 4, 6 ] ]
        , test "step 1.3" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 3 ] [ 5, 6 ])
                    [ [ 2, 3, 5 ], [ 2, 3, 6 ] ]
        , test "step 1.4" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4 ] [ 5, 6 ])
                    [ [ 2, 4, 5 ], [ 2, 4, 6 ] ]

        {- loop the result list [[1,3,5],[1,3,6],[1,4,5],[1,4,6],[2,3,5],[2,3,6],[2,4,5],[2,4,6]] and apply cartesian with the next list [7,8] -}
        , test "step 2.1 now we can append the previous results with the [7,8]" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 3, 5 ] [ 7, 8 ])
                    [ [ 1, 3, 5, 7 ], [ 1, 3, 5, 8 ] ]
        , test "step 2.2" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 3, 6 ] [ 7, 8 ])
                    [ [ 1, 3, 6, 7 ], [ 1, 3, 6, 8 ] ]
        , test "step 2.3" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 4, 5 ] [ 7, 8 ])
                    [ [ 1, 4, 5, 7 ], [ 1, 4, 5, 8 ] ]
        , test "step 2.4" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 1, 4, 6 ] [ 7, 8 ])
                    [ [ 1, 4, 6, 7 ], [ 1, 4, 6, 8 ] ]
        , test "step 2.5" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 3, 5 ] [ 7, 8 ])
                    [ [ 2, 3, 5, 7 ], [ 2, 3, 5, 8 ] ]
        , test "step 2.6" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4, 6 ] [ 7, 8 ])
                    [ [ 2, 4, 6, 7 ], [ 2, 4, 6, 8 ] ]
        , test "step 2.7" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4, 5 ] [ 7, 8 ])
                    [ [ 2, 4, 5, 7 ], [ 2, 4, 5, 8 ] ]
        , test "step 2.8" <|
            \() ->
                Expect.equal
                    (cartesianHelper [ 2, 4, 6 ] [ 7, 8 ])
                    [ [ 2, 4, 6, 7 ], [ 2, 4, 6, 8 ] ]

        {-
           after having processed the final List, all we need to do is combine all of the List of Lists into one List of Lists
           e.g. [ [ 2, 4, 5, 7 ], [ 2, 4, 5, 8 ] ] ++ [ [ 2, 4, 6, 7 ], [ 2, 4, 6, 8 ] ]
        -}
        ]


cartesianHelper : List a -> List a -> List (List a)
cartesianHelper xs ys =
    case ys of
        [] ->
            []

        h :: t ->
            [ xs ++ [ h ] ] ++ (cartesianHelper xs t)



-- generateCombinationsTests : Test
-- generateCombinationsTests =
--     describe "generateCombinations"
--         [ test "one denom with 4 chips has 4 combinations" <|
--             \() ->
--                 let
--                     simple =
--                         [ { color = "orange", amount = 4, denom = 0.1 } ]
--                 in
--                     Expect.equal
--                         (generateCombinations 0.4 simple)
--                         { toDistribute = 30, usedValues = [ 1 ], innerData = { amountOfChipsUsed = 1 } }
--         , test "recursion" <|
--             \() ->
--                 let
--                     simple =
--                         [ { color = "orange", amount = 4, denom = 0.1 } ]
--                 in
--                     Expect.equal
--                         (generateComboRecursively simple <| InnerData 0)
--                         [ { toDistribute = 30, usedValues = [ 1 ], innerData = { amountOfChipsUsed = 1 } }
--                         , { toDistribute = 20, usedValues = [ 2 ], innerData = { amountOfChipsUsed = 2 } }
--                         , { toDistribute = 10, usedValues = [ 3 ], innerData = { amountOfChipsUsed = 3 } }
--                         , { toDistribute = 0, usedValues = [ 4 ], innerData = { amountOfChipsUsed = 4 } }
--                         ]
--         ]
