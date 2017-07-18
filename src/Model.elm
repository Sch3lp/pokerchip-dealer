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
    List ChipsInColorWithValue


type alias StackWorth =
    Float


stackWorth : Stack -> StackWorth
stackWorth stack =
    toFloat (List.sum <| List.map chipsValue stack) / 100


type alias ChipsInColor =
    { color : String, amount : Amount }


type alias ChipsInColorWithValue =
    { color : String, amount : Amount, value : Value }


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


standardDenomValues : List Value
standardDenomValues =
    [ 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000 ]


toDenom : Value -> Denomination
toDenom val =
    toFloat val / 100
