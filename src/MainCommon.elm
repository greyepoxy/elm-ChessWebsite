module MainCommon (..) where

import Window
import Effects exposing (Effects, Never)
import StartApp
import App.Model exposing (initialModel, AppModel)
import App.Actions exposing (Action(Resize))
import App.Update exposing (update)
import App.View exposing (view)

--TODO: delete!
import Debug

init : (Int,Int) -> ( AppModel, Effects Action )
init initialWindowDimensions =
  ( initialModel initialWindowDimensions, Effects.none )

app : (Int,Int) -> List (Signal Action) -> StartApp.App AppModel
app initialWindowDimensions extraSignals =
  StartApp.start
    { init = init initialWindowDimensions
    , inputs = List.append extraSignals [windowDimensions]
    , update = update
    , view = view
    }

windowDimensions : Signal Action
windowDimensions = 
  Signal.map Resize Window.dimensions
