module Model exposing (..)


type alias Model =
    { pokerset : PokerSet
    , buyin : Buyin
    , players : Players
    }


type alias Players =
    Int


type alias Buyin =
    Int


type alias PokerSet =
    Stack


type alias Stack =
    List ChipsInColor


type alias ChipsInColor =
    ( String, Int )


pokersetToString : PokerSet -> List String
pokersetToString pokerset =
    List.map chipsInColorToString pokerset


chipsInColorToString : ChipsInColor -> String
chipsInColorToString ( color, amount ) =
    (toString amount) ++ " " ++ color ++ " chips"
