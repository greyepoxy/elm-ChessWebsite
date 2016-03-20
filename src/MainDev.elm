module MainDev (..) where

import Html exposing (Html)
import Task exposing (Task)
import Effects exposing (Never)
import MainCommon
import App.Actions exposing (Action(NoOp))

app = MainCommon.app initialWindowDimensions [swapsignal]

main : Signal Html
main =
  app.html

port runner : Signal (Task Never ())
port runner =
  app.tasks

port initialWindowDimensions : (Int, Int)

-- for elm-hot-loader to trigger a re-render
port swap : Signal Bool

-- map swap to Empty action
swapsignal : Signal Action
swapsignal =
  Signal.map (\_ -> NoOp) swap
