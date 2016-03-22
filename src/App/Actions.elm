module App.Actions (..) where

import App.Chessboard.Actions

type Action
  = NoOp
  | Resize (Int, Int)
  | ChildBoardActions App.Chessboard.Actions.Action
