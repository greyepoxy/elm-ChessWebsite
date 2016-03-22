module App.Chessboard.Update (..) where

import App.Chessboard.Model exposing (..)
import App.Chessboard.Actions exposing (..)
import Effects exposing (Effects)


update : Action -> Chessboard -> ( Chessboard, Effects Action )
update action model =
  ( model, Effects.none )
