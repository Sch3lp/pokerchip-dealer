module Cartesian exposing (..)

import Lazy exposing (lazy, force)
import Lazy.List exposing (LazyList, LazyListView(Nil, Cons), (+++))


lazyCartesian : List (List a) -> LazyList (List a)
lazyCartesian xss =
    case List.reverse xss of
        [] ->
            Lazy.List.empty

        head :: tail ->
            List.foldl (lazyCartesianHelper << Lazy.List.fromList)
                (List.map (\x -> x :: []) head |> Lazy.List.fromList)
                tail


lazyCartesianHelper : LazyList a -> LazyList (List a) -> LazyList (List a)
lazyCartesianHelper xs xss =
    lazy <|
        (\() ->
            case force xs of
                Nil ->
                    Nil

                Cons first1 rest1 ->
                    case force xss of
                        Nil ->
                            Nil

                        Cons _ _ ->
                            force <| Lazy.List.map ((::) first1) xss +++ lazyCartesianHelper rest1 xss
        )


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



-- Alternative using concatMap, thanks to @gilbert in elmlang.slack.com
-- cartesianRecursive : List (List a) -> List (List a)
-- cartesianRecursive xss =
--     case List.reverse xss of
--         [] ->
--             []
--         head :: tail ->
--             List.foldl
--                 (\xs acc ->
--                     List.concatMap (\x -> List.map ((::) x) acc) xs
--                 )
--                 (List.map (\x -> x :: []) head)
--                 tail


reduceWithCartesian : List a -> List (List a) -> List (List a)
reduceWithCartesian otherList acc =
    List.foldl (\other tmpAcc -> (cartesianHelper other otherList) ++ tmpAcc) [] acc


cartesianHelper : List a -> List a -> List (List a)
cartesianHelper xs ys =
    List.foldl (\y acc -> (xs ++ [ y ]) :: acc) [] ys



{- currently unused -}


cartesian : List a -> List a -> List ( a, a )
cartesian xs ys =
    List.concatMap
        (\x -> List.map (\y -> ( x, y )) ys)
        xs


cartesianToList : List a -> List a -> List (List a)
cartesianToList xs ys =
    List.concatMap (\x -> List.map (\y -> x :: [ y ]) ys) xs
