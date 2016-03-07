module App.Actions (..) where

import App.Components.Chessboard.Actions

type Action
  = NoOp
  | ChildBoardActions App.Components.Chessboard.Actions.Action
