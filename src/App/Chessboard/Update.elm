module App.Chessboard.Update (..) where

import App.Chessboard.Model exposing (..)
import App.Chessboard.Actions exposing (..)
import Effects exposing (Effects)

update : Action -> Chessboard -> ( Chessboard, Effects Action )
update action model =
  case action of
    NoOp -> ( model, Effects.none )
    SelectLocation loc -> ( 
      { model | 
        selectedSquareLoc= (updateSelectedSquareLoc model.selectedSquareLoc loc)
      }
      , Effects.none )

updateSelectedSquareLoc: Maybe (Int,Int) -> (Int, Int) -> Maybe (Int, Int)
updateSelectedSquareLoc previousSelectedLoc newSelectedLoc=
  case previousSelectedLoc of
    Nothing -> Just newSelectedLoc
    Just _ -> Nothing
