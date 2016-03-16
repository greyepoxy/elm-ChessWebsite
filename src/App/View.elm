module App.View (..) where

import Html exposing (..)
import App.Actions exposing (..)
import App.Model exposing (..)


import App.Components.ChessPieces exposing (..)

import App.Components.Chessboard.Model exposing (Chessboard)
import App.Components.Chessboard.View
import App.Components.Chessboard.Actions

view : Signal.Address Action -> AppModel -> Html
view address model =
  let
    childChessboardActions =
        Signal.forwardTo address ChildBoardActions
  in
    div
      []
      [ App.Components.Chessboard.View.view childChessboardActions model.chessboard ]
