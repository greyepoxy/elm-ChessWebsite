module App.Chessboard.Model (
  Team(White,Black)
  , ChessPiece(King,Queen,Rook,Bishop,Knight,Pawn)
  , BoardSquare(Empty,FilledWith)
  , Row, Chessboard, InteractiveChessboard, initialBoard, getPossibleMoveLocations) where

import Array exposing (Array)

type Team
  = White
  | Black

type ChessPiece
  = King
  | Queen
  | Rook
  | Bishop
  | Knight
  | Pawn


type BoardSquare
  = Empty
  | FilledWith Team ChessPiece

type alias Row = Array BoardSquare

type alias Chessboard = Array Row

type alias InteractiveChessboard = {
    squares: Array Row
    , selectedSquareLoc: Maybe (Int,Int)
  }

initialBoard : InteractiveChessboard
initialBoard = {
    squares = Array.fromList [
      getInitialTopOrBottomRow White
      , Array.repeat 8 (FilledWith White Pawn)
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 (FilledWith Black Pawn)
      , getInitialTopOrBottomRow Black
    ]
    , selectedSquareLoc = Nothing
  }

getInitialTopOrBottomRow : Team -> Array BoardSquare
getInitialTopOrBottomRow team = Array.fromList [
    FilledWith team Rook
    , FilledWith team Knight
    , FilledWith team Bishop
    , FilledWith team Queen
    , FilledWith team King
    , FilledWith team Bishop
    , FilledWith team Knight
    , FilledWith team Rook
  ]

type alias BoardSquareWithLoc = {
    boardPosition: (Int,Int)
    , square: BoardSquare
  }

{--
  Get every possible move location for a given board square
  at the given location in the given chessboard. 
--}
getPossibleMoveLocations: (Int,Int) -> Chessboard -> List (Int, Int)
getPossibleMoveLocations testLoc board =
  let
    maybeSquare = getBoardSquareAtLocation testLoc board
  in
    case maybeSquare of
      Nothing -> []
      Just square -> case square of
        Empty -> []
        FilledWith team piece ->
          case piece of
            Pawn -> 
              getIdealPawnMoveLocations team testLoc 
                |> List.filter (isValidMoveLocForPieceOfTeam team board)
                |> List.map (\moveLoc -> moveLoc.loc)
            _ -> []

getBoardSquareAtLocation: (Int,Int) -> Chessboard -> Maybe BoardSquare
getBoardSquareAtLocation (x,y) board =
  Array.get y board
    `Maybe.andThen` Array.get x

type CanMoveIf = 
  LocationEmpty
  | LocationContainsOpponent

type alias MoveLoc = {
    conditions: CanMoveIf
    , loc: (Int, Int)
  }
 
isValidMoveLocForPieceOfTeam: Team -> Chessboard -> MoveLoc -> Bool
isValidMoveLocForPieceOfTeam movingPiecesTeam board moveLoc =
  let
    maybeBoardSquareAtLoc = getBoardSquareAtLocation moveLoc.loc board
  in
    case maybeBoardSquareAtLoc of
      Nothing -> False
      Just Empty -> moveLoc.conditions == LocationEmpty
      Just (FilledWith team _) -> moveLoc.conditions == LocationContainsOpponent && movingPiecesTeam /= team

getIdealPawnMoveLocations: Team -> (Int,Int) -> List MoveLoc
getIdealPawnMoveLocations team (curX,curY) =
  let
    moveDir = if team == White then 1 else -1
    atStartLoc = case team of
      White -> if curY == 1 then True else False
      Black -> if curY == 6 then True else False
    additionalMoveLoc = if atStartLoc then [{conditions = LocationEmpty, loc = (curX,curY+2*moveDir)}] else [] 
  in
    [{conditions = LocationEmpty, loc = (curX,curY+moveDir)}
      , {conditions = LocationContainsOpponent, loc = (curX+1,curY+moveDir)}
      , {conditions = LocationContainsOpponent, loc = (curX-1,curY+moveDir)}
    ]
      |> List.append additionalMoveLoc
