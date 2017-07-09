module Update exposing (..)

import Model exposing (..)
import Greedy exposing (greedySolve)


type Msg
    = Fuck


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


solve : Model -> Stack
solve model =
    greedySolve model
