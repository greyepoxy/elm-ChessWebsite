module App.Actions (..) where

import App.Components.Chessboard.Actions

type Action
  = NoOp
  | SetWindowDimensions (Int, Int)
  | ChildBoardActions App.Components.Chessboard.Actions.Action
