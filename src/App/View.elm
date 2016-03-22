module App.View (..) where

import Html exposing (..)
import Html.Attributes
import App.Actions exposing (..)
import App.Model exposing (..)


import App.ChessPieces exposing (..)

import App.Chessboard.Model exposing (Chessboard)
import App.Chessboard.View
import App.Chessboard.Actions

view : Signal.Address Action -> AppModel -> Html
view address model =
  let
    childChessboardActions =
        Signal.forwardTo address ChildBoardActions
  in
    div [ Html.Attributes.class "flex" ]
    [
      div [ Html.Attributes.class "col-1" ] []
      , div [ Html.Attributes.class "col-10 flex flex-column" ]
        [
          div [ Html.Attributes.style [("height", "40px")] ] []
          , App.Chessboard.View.view childChessboardActions model.chessboard
          , div [ Html.Attributes.style [("height", "40px")] ] []
        ]
      , div [ Html.Attributes.class "col-1" ] []
    ]
