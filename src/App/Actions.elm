module App.Actions (..) where

import App.Components.Chessboard.Actions

type Action
  = NoOp
  | Resize (Int, Int)
  | ChildBoardActions App.Components.Chessboard.Actions.Action
