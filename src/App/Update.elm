module App.Update exposing (..)

import App.Model exposing (..)
import App.Messages exposing (..)
import App.Chessboard.Update
import Platform.Cmd exposing (Cmd)


update : Message -> AppModel -> ( AppModel, Cmd Message )
update action model =
  case action of
    NoOp -> ( model, Cmd.none )
    Resize dimensions -> ( {model | windowDimensions = dimensions }, Cmd.none )
    ChildBoardMessages msg ->
      let
        (newChessboard, cmds) = App.Chessboard.Update.update msg model.chessboard
      in
        ( {model | chessboard = newChessboard }, Cmd.map (\a -> ChildBoardMessages a) cmds )
