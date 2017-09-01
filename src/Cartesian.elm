module Cartesian exposing (..)


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
        loop tmpAcc rest =
            case rest of
                [] ->
                    tmpAcc

                h :: t ->
                    let
                        tmp =
                            (cartesianHelper h otherList) ++ tmpAcc
                    in
                        loop tmp t
    in
        loop [] acc


cartesianHelper : List a -> List a -> List (List a)
cartesianHelper xs ys =
    cartesianHelper_ [] xs ys


cartesianHelper_ : List (List a) -> List a -> List a -> List (List a)
cartesianHelper_ acc xs ys =
    case ys of
        [] ->
            acc

        h :: t ->
            let
                tmp =
                    [ xs ++ [ h ] ] ++ acc
            in
                cartesianHelper_ tmp xs t



{- currently unused -}


cartesian : List a -> List a -> List ( a, a )
cartesian xs ys =
    List.concatMap
        (\x -> List.map (\y -> ( x, y )) ys)
        xs


cartesianToList : List a -> List a -> List (List a)
cartesianToList xs ys =
    List.concatMap (\x -> List.map (\y -> x :: [ y ]) ys) xs
