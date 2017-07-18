module Model exposing (..)


type alias Model =
    { pokerset : PokerSet
    , denoms : List Value
    , buyin : Buyin
    , players : Players
    }


type alias Players =
    Int


type alias Buyin =
    Float


type alias PokerSet =
    List ChipsInColor


type alias Stack =
    List ChipsInColorWithDenom


type alias StackWorth =
    Float


stackWorth : Stack -> StackWorth
stackWorth stack =
    List.sum <| List.map chipValue stack


type alias ChipsInColor =
    { color : String, amount : Amount }


type alias ChipsInColorWithValue =
    { color : String, amount : Amount, value : Value }


type alias ChipsInColorWithDenom =
    { color : String, amount : Amount, denom : Denomination }


chipValue : ChipsInColorWithDenom -> Float
chipValue chips =
    toFloat chips.amount * chips.denom


chipsValue : ChipsInColorWithValue -> Int
chipsValue chips =
    chips.amount * chips.value


subtractChips : Int -> ChipsInColorWithValue -> ChipsInColorWithValue
subtractChips amountToSubtract chips =
    let
        subtractedAmount =
            chips.amount - amountToSubtract
    in
        { chips | amount = subtractedAmount }


type alias Amount =
    Int


pokersetToString : PokerSet -> List String
pokersetToString pokerset =
    List.map chipsInColorToString pokerset


chipsInColorToString : ChipsInColor -> String
chipsInColorToString { color, amount } =
    (toString amount) ++ " " ++ color ++ " chips"


chipsInColorWithValueToString : ChipsInColorWithValue -> String
chipsInColorWithValueToString { color, amount, value } =
    (toString amount) ++ " " ++ color ++ " chips"



-- Value and Denomination stuff


type alias Value =
    Int


type alias Denomination =
    Float


convertToDenomBase : Float -> Int
convertToDenomBase value =
    round (value * denomBase)


denomBase : number
denomBase =
    100


standardDenoms : List Denomination
standardDenoms =
    [ 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, 25, 50, 100 ]


standardDenomValues : List Value
standardDenomValues =
    List.map toValue standardDenoms


toValue : Denomination -> Value
toValue denom =
    convertToDenomBase denom


toDenom : Value -> Denomination
toDenom val =
    toFloat val / denomBase


toChipsWithValue : ChipsInColor -> Value -> ChipsInColorWithValue
toChipsWithValue { color, amount } value =
    ChipsInColorWithValue color amount value


toChipsWithDenomination : ChipsInColor -> Denomination -> ChipsInColorWithDenom
toChipsWithDenomination { color, amount } denom =
    ChipsInColorWithDenom color amount denom


chipsWithDenomToValue : ChipsInColorWithDenom -> ChipsInColorWithValue
chipsWithDenomToValue { color, amount, denom } =
    ChipsInColorWithValue color amount (convertToDenomBase denom)
