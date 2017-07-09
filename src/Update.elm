module Update exposing (..)

import Model exposing (..)


type Msg
    = Fuck


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
