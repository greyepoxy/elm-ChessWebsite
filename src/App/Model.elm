module App.Model (..) where

import App.Components.Chessboard.Model exposing (..)

type alias AppModel = {
    chessboard: Chessboard
    , windowDimensions: (Int, Int)
  }


initialModel : (Int,Int) -> AppModel
initialModel initialWindowDimensions = {
    chessboard = initialBoard
    , windowDimensions = initialWindowDimensions
  }
