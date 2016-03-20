module App.Update (..) where

import App.Model exposing (..)
import App.Actions exposing (..)
import App.Components.Chessboard.Model
import App.Components.Chessboard.Update
import Effects exposing (Effects)


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case action of
    NoOp -> ( model, Effects.none )
    Resize dimensions -> ( {model | windowDimensions = Just dimensions }, Effects.none )
    ChildBoardActions action ->
      let
        (newChessboard, effects) = App.Components.Chessboard.Update.update action model.chessboard
      in
        ( {model | chessboard = newChessboard }, Effects.map (\a -> ChildBoardActions a) effects )
