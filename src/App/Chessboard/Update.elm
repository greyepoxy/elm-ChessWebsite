module App.Chessboard.Update (..) where

import App.Chessboard.Model exposing (..)
import App.Chessboard.Actions exposing (..)
import Effects exposing (Effects)

update : Action -> InteractiveChessboard -> ( InteractiveChessboard, Effects Action )
update action model =
  case action of
    NoOp -> ( model, Effects.none )
    SelectLocation loc -> ( 
      updateBasedOnSelectedLocAction loc model
      , Effects.none )

updateBasedOnSelectedLocAction: (Int,Int) -> InteractiveChessboard -> InteractiveChessboard
updateBasedOnSelectedLocAction newSelectedLoc previousModel =
  case previousModel.selectedSquareLoc of
    Nothing -> { previousModel | 
        selectedSquareLoc = 
          let
            isPlayersTurn = isPlayersTurnForPieceAtLocation newSelectedLoc previousModel.gameState
          in
            if isPlayersTurn then (Just newSelectedLoc) else Nothing
      }
    Just startLoc -> { previousModel | 
        selectedSquareLoc = Nothing
        , gameState = tryMovePiece previousModel.gameState startLoc newSelectedLoc
      }
