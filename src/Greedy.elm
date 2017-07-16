module Greedy exposing (..)

import Debug exposing (..)
import Model exposing (..)
import Util exposing (..)


type alias MaxStackValue =
    Float


greedySolve : Model -> Stack
greedySolve model =
    let
        data =
            Debug.log "data" <| greedyChange model.buyin <| to2314 standardDenomValues

        stack =
            assignPreferredDenominationValues standardDenomValues model.pokerset

        stackIn3124Reversed =
            List.reverse <| to2314 stack

        greedyStack =
            List.map2 combineDenoms data.usedValues stackIn3124Reversed
    in
        List.reverse greedyStack



-- prep


assignPreferredDenominationValues : List Value -> PokerSet -> Stack
assignPreferredDenominationValues values pokerset =
    let
        valuesSortedAsc =
            List.sort values

        chipsIn3124Order =
            to3124WhenDifferentAmounts <| sortedByAmountDesc pokerset
    in
        List.map2 toChipsWithValue chipsIn3124Order valuesSortedAsc


to3124WhenDifferentAmounts : PokerSet -> PokerSet
to3124WhenDifferentAmounts pokerset =
    if hasAllSame <| List.map .amount <| pokerset then
        pokerset
    else if hasAllSame <| List.take 3 <| List.map .amount pokerset then
        List.append (List.take 3 pokerset) (sortedByAmountDesc <| List.drop 3 pokerset)
    else
        to3124 <| sortedByAmountDesc pokerset



-- finalize


combineDenoms : Value -> ChipsInColorWithValue -> ChipsInColorWithValue
combineDenoms value chipsInColorWithValue =
    { chipsInColorWithValue | amount = value }



-- greedy solve


type alias Data =
    { buyinToDistribute : Int, usedValues : List Value }


greedyChange : Buyin -> List Value -> Data
greedyChange buyin denomValues =
    let
        buyinToDistribute =
            floor (buyin * 100)

        -- TODO: preferred order is ok, but makeChange doesn't take into account available chips
        denomsToUse =
            Debug.log "using denoms" denomValues

        initialData =
            Data buyinToDistribute []
    in
        List.foldl makeChangeForDenom initialData denomsToUse


makeChangeForDenom : Value -> Data -> Data
makeChangeForDenom value data =
    let
        remaining =
            Debug.log "remaining" <| data.buyinToDistribute % value

        usedValues =
            Debug.log "usedValues" <| data.buyinToDistribute // value
    in
        { data
            | buyinToDistribute =
                remaining
            , usedValues =
                usedValues :: data.usedValues
        }



-- Util


sortedByAmountDesc : PokerSet -> PokerSet
sortedByAmountDesc pokerset =
    sortWithDesc .amount <| pokerset


toChipsWithValue : ChipsInColor -> Value -> ChipsInColorWithValue
toChipsWithValue { color, amount } value =
    ChipsInColorWithValue color amount value


limitAmount : Players -> PokerSet -> PokerSet
limitAmount players pokerset =
    List.map (limitAmountOfChips players) pokerset


limitAmountOfChips : Players -> ChipsInColor -> ChipsInColor
limitAmountOfChips players { color, amount } =
    ChipsInColor color (amount // players)


limitChipsByPlayers : Players -> Stack -> Stack
limitChipsByPlayers players stack =
    List.map (divideAmountBy players) stack


divideAmountBy : Players -> ChipsInColorWithValue -> ChipsInColorWithValue
divideAmountBy players chips =
    let
        newAmount =
            floor <| (toFloat chips.amount / toFloat players)
    in
        { chips | amount = newAmount }
