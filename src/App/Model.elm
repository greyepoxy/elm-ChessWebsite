module App.Model (..) where

import App.Components.Chessboard.Model exposing (..)

type alias AppModel = {
    chessboard: Chessboard
    , windowDimensions: (Int, Int)
  }


initialModel : AppModel
initialModel = {
    chessboard = initialBoard
    , windowDimensions = (500,500)
  }
