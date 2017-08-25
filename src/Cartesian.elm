module Cartesian exposing (..)

import Trampoline exposing (done, jump, evaluate, Trampoline)


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


cartesianHelper : List a -> List a -> List (List a)
cartesianHelper xs ys =
    evaluate <| cartesianHelper_ [] xs ys


cartesianHelper_ : List (List a) -> List a -> List a -> Trampoline (List (List a))
cartesianHelper_ acc xs ys =
    case ys of
        [] ->
            done acc

        h :: t ->
            let
                tmp =
                    [ xs ++ [ h ] ] ++ acc
            in
                jump (\_ -> cartesianHelper_ tmp xs t)



{- currently unused -}


cartesian : List a -> List a -> List ( a, a )
cartesian xs ys =
    List.concatMap
        (\x -> List.map (\y -> ( x, y )) ys)
        xs


cartesianToList : List a -> List a -> List (List a)
cartesianToList xs ys =
    List.concatMap (\x -> List.map (\y -> x :: [ y ]) ys) xs
