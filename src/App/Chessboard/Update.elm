module App.Chessboard.Update (..) where

import App.Chessboard.Model exposing (..)
import App.Chessboard.Actions exposing (..)
import Effects exposing (Effects)

update : Action -> Chessboard -> ( Chessboard, Effects Action )
update action model =
  case action of
    NoOp -> ( model, Effects.none )
    StartMovingPieceAt (x,y) -> ( {model | selectedSquareLoc= Just (x,y)} , Effects.none )
    StopMovingPieceAt maybeALoc -> ( {model | selectedSquareLoc= Nothing}, Effects.none )
