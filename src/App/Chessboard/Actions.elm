module App.Chessboard.Actions (..) where

type Action
  = NoOp
    | StartMovingPieceAt (Int, Int)
    | StopMovingPieceAt (Maybe (Int, Int))
