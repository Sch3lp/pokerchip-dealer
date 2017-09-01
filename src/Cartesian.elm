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
