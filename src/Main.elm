module Main (..) where

import Html exposing (Html)
import Task exposing (Task)
import Effects exposing (Never)
import MainCommon
import App.Actions exposing (Action(NoOp))

app = MainCommon.app initialWindowDimensions []

main : Signal Html
main =
  app.html

port runner : Signal (Task Never ())
port runner =
  app.tasks

port initialWindowDimensions : (Int, Int)
