module App.View exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes
import App.Messages exposing (..)
import App.Model exposing (..)

import App.Chessboard.View

view : AppModel -> Html Message
view model =
  div [ Html.Attributes.class "flex" ]
  [
    div [ Html.Attributes.class "col-1" ] []
    , div [ Html.Attributes.class "col-10 flex flex-column" ]
      [
        div [ Html.Attributes.style [("height", "40px")] ] []
        , Html.App.map ChildBoardMessages (App.Chessboard.View.view model.chessboard)
        , div [ Html.Attributes.style [("height", "40px")] ] []
      ]
    , div [ Html.Attributes.class "col-1" ] []
  ]
