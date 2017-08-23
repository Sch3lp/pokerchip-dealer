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
    case ys of
        [] ->
            []

        h :: t ->
            [ xs ++ [ h ] ] ++ (cartesianHelper xs t)



{- currently unused -}


cartesian : List a -> List a -> List ( a, a )
cartesian xs ys =
    List.concatMap
        (\x -> List.map (\y -> ( x, y )) ys)
        xs


cartesianToList : List a -> List a -> List (List a)
cartesianToList xs ys =
    List.concatMap (\x -> List.map (\y -> x :: [ y ]) ys) xs
