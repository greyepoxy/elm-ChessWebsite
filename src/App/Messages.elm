module App.Messages exposing (..)

import App.Chessboard.Messages

type Message
  = NoOp
  | Resize (Int, Int)
  | ChildBoardMessages App.Chessboard.Messages.Message
