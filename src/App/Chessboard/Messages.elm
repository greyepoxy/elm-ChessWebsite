module App.Chessboard.Messages exposing (..)

type Message
  = NoOp
    | SelectLocation (Int, Int)
