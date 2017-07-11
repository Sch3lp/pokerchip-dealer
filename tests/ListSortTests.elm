module ListSortTests exposing (..)

import Test exposing (..)
import Expect


dafuq : Test
dafuq =
    describe "List.sortBy BS"
        [ test ".sortBy default is asc" <|
            \() ->
                let
                    input =
                        [ { id = 3, text = "shit" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 1, text = "what" } ]

                    expected =
                        [ { id = 1, text = "what" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 3, text = "shit" } ]
                in
                    Expect.equal (List.sortBy .id input) expected
        , test ".sortBy and reverse messes up equal order" <|
            \() ->
                let
                    input =
                        [ { id = 1, text = "shit" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 3, text = "what" } ]

                    expected =
                        [ { id = 3, text = "what" }, { id = 2, text = "dis" }, { id = 2, text = "is" }, { id = 1, text = "shit" } ]
                in
                    Expect.equal (List.reverse <| List.sortBy .id input) expected
        , test ".sortWith is not generic" <|
            \() ->
                let
                    input =
                        [ { id = 1, text = "shit" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 3, text = "what" } ]

                    expected =
                        [ { id = 3, text = "what" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 1, text = "shit" } ]

                    descCompare : { id : Int, text : string } -> { id : Int, text : string } -> Order
                    descCompare a b =
                        case compare a.id b.id of
                            LT ->
                                GT

                            EQ ->
                                EQ

                            GT ->
                                LT
                in
                    Expect.equal (List.sortWith descCompare input) expected
        , test ".sortWith using function composition" <|
            \() ->
                let
                    input =
                        [ { id = 1, text = "shit" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 3, text = "what" } ]

                    expected =
                        [ { id = 3, text = "what" }, { id = 2, text = "is" }, { id = 2, text = "dis" }, { id = 1, text = "shit" } ]

                    desc : (a -> comparable) -> (a -> a -> Order)
                    desc extractor left right =
                        case compare (extractor left) (extractor right) of
                            LT ->
                                GT

                            EQ ->
                                EQ

                            GT ->
                                LT

                    sortWithDesc : (a -> comparable) -> List a -> List a
                    sortWithDesc extractor =
                        List.sortWith <| desc <| extractor
                in
                    Expect.equal (sortWithDesc .id input) expected
        ]
