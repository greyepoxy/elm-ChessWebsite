module App.Chessboard.Actions (..) where

type Action
  = NoOp
    | SelectLocation (Int, Int)
