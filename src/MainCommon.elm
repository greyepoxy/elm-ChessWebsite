module MainCommon (..) where

import Window
import Effects exposing (Effects, Never)
import StartApp
import App.Model exposing (initialModel, AppModel)
import App.Actions exposing (Action(SetWindowDimensions))
import App.Update exposing (update)
import App.View exposing (view)

--TODO: delete!
import Debug

init : ( AppModel, Effects Action )
init =
  ( initialModel, Effects.none )

app : List (Signal Action) -> StartApp.App AppModel
app extraSignals =
  StartApp.start
    { init = init
    , inputs = List.append extraSignals [windowDimensions]
    , update = update
    , view = view
    }

windowDimensions : Signal Action
windowDimensions = 
  Signal.map (\dimensions -> SetWindowDimensions (Debug.log "dimensions" dimensions)) Window.dimensions
