module MainCommon (..) where

import Effects exposing (Effects, Never)
import StartApp
import App.Model exposing (initialModel, AppModel)
import App.Actions exposing (Action)
import App.Update exposing (update)
import App.View exposing (view)

init : ( AppModel, Effects Action )
init =
  ( initialModel, Effects.none )

app : List (Signal Action) -> StartApp.App AppModel
app extraSignals =
  StartApp.start
    { init = init
    , inputs = extraSignals
    , update = update
    , view = view
    }
