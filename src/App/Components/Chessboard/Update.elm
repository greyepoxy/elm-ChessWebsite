module App.Components.Chessboard.Update (..) where

import App.Components.Chessboard.Model exposing (..)
import App.Components.Chessboard.Actions exposing (..)
import Effects exposing (Effects)


update : Action -> Chessboard -> ( Chessboard, Effects Action )
update action model =
  ( model, Effects.none )
