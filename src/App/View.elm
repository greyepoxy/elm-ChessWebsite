module App.View (..) where

import Html exposing (..)
import Html.Attributes
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
    div [ Html.Attributes.class "flex" ]
    [
      div [ Html.Attributes.class "col-1" ] []
      , div [ Html.Attributes.class "col-10 flex flex-column" ]
        [
          div [ Html.Attributes.style [("height", "40px")] ] []
          , App.Components.Chessboard.View.view childChessboardActions model.chessboard
          , div [ Html.Attributes.style [("height", "40px")] ] []
        ]
      , div [ Html.Attributes.class "col-1" ] []
    ]
