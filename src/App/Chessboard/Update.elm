module App.Chessboard.Update exposing (..)

import App.Chessboard.Model exposing (..)
import App.Chessboard.Messages exposing (..)
import Platform.Cmd exposing (Cmd)

update : Message -> InteractiveChessboard -> ( InteractiveChessboard, Cmd Message )
update action model =
  case action of
    NoOp -> ( model, Cmd.none )
    SelectLocation loc -> ( 
      updateBasedOnSelectedLocAction loc model
      , Cmd.none )

updateBasedOnSelectedLocAction: (Int,Int) -> InteractiveChessboard -> InteractiveChessboard
updateBasedOnSelectedLocAction newSelectedLoc previousModel =
  case previousModel.selectedSquareLoc of
    Nothing -> selectLocation newSelectedLoc previousModel
    Just startLoc ->
      let
        isPieceAtNewSelectedLocPlayers = isPlayersTurnForPieceAtLocation newSelectedLoc previousModel.gameState
      in
        case isPieceAtNewSelectedLocPlayers of
          True -> selectLocation newSelectedLoc previousModel
          False -> { previousModel | 
              selectedSquareLoc = Nothing
              , gameState = tryMovePiece previousModel.gameState startLoc newSelectedLoc
            }

selectLocation: (Int,Int) -> InteractiveChessboard -> InteractiveChessboard
selectLocation newSelectedLoc previousModel =
  let
    isPlayersTurn = isPlayersTurnForPieceAtLocation newSelectedLoc previousModel.gameState
    actualSelectedLoc = if isPlayersTurn then (Just newSelectedLoc) else Nothing 
  in
    { previousModel | selectedSquareLoc = actualSelectedLoc }
