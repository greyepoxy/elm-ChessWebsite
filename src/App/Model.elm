module App.Model (..) where

import App.Chessboard.Model exposing (..)

type alias AppModel = {
    chessboard: InteractiveChessboard
    , windowDimensions: (Int, Int)
  }


initialModel : (Int,Int) -> AppModel
initialModel initialWindowDimensions = {
    chessboard = initialBoard
    , windowDimensions = initialWindowDimensions
  }
