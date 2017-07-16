module Util exposing (..)

import Set


desc : (a -> comparable) -> (a -> a -> Order)
desc extractor left right =
    case compare (extractor left) (extractor right) of
        EQ ->
            EQ

        LT ->
            GT

        GT ->
            LT


sortWithDesc : (a -> comparable) -> List a -> List a
sortWithDesc extractor =
    List.sortWith <| desc <| extractor


to3214 : List a -> List a
to3214 list =
    case list of
        one :: two :: three :: t ->
            three :: two :: one :: t

        list ->
            list


to3124 : List a -> List a
to3124 list =
    case list of
        one :: two :: three :: t ->
            three :: one :: two :: t

        list ->
            list


to2314 : List a -> List a
to2314 list =
    case list of
        one :: two :: three :: t ->
            two :: three :: one :: t

        list ->
            list


hasAllSame : List comparable -> Bool
hasAllSame list =
    case list of
        [] ->
            True

        h :: [] ->
            True

        list ->
            1 == (Set.size <| Set.fromList list)
