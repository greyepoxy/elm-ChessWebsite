module App.Model (..) where

import App.Components.Chessboard.Model exposing (..)

type alias AppModel = {
    chessboard: Chessboard
  }


initialModel : AppModel
initialModel = {
    chessboard = initialBoard
  }
