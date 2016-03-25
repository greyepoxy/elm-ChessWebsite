module App.Chessboard.Model (
  Team(White,Black)
  , ChessPiece(King,Queen,Rook,Bishop,Knight,Pawn)
  , BoardSquare(Empty,FilledWith)
  , Row, Chessboard, initialBoard, getPossibleMoveLocations) where

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

type alias Chessboard = {
    squares: Array Row
    , selectedSquareLoc: Maybe (Int,Int)
  }  

initialBoard : Chessboard
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
getPossibleMoveLocations: Chessboard -> (Int,Int) -> List (Int, Int)
getPossibleMoveLocations board testLoc =
  let
    maybeSquare = getBoardSquareAtLocation board testLoc
  in
    case maybeSquare of
      Nothing -> []
      Just square -> case square of
        Empty -> []
        FilledWith team piece ->
          case piece of
            Pawn -> 
              getIdealPawnMoveLocations team testLoc 
                |> List.filter (canPieceMoveToLoc board)
                |> List.map (\moveLoc -> moveLoc.loc)
            _ -> []

getBoardSquareAtLocation: Chessboard -> (Int,Int) -> Maybe BoardSquare
getBoardSquareAtLocation board (x,y) =
  Array.get y board.squares
    `Maybe.andThen` Array.get x

type CanMoveIf = 
  LocationEmpty
  | LocationContainsOpponent

type alias MoveLoc = {
    conditions: CanMoveIf
    , loc: (Int, Int)
  }
 
canPieceMoveToLoc: Chessboard -> MoveLoc -> Bool
canPieceMoveToLoc board moveLoc =
  True

getIdealPawnMoveLocations: Team -> (Int,Int) -> List MoveLoc
getIdealPawnMoveLocations team (curX,curY) =
  let
    moveDir = if team == White then 1 else -1
    atStartLoc = case team of
      White -> if curY == 1 then True else False
      Black -> if curY == 6 then True else False
    additionalMoveLoc = if atStartLoc then [{conditions = LocationEmpty, loc = (curX,curY+2*moveDir)}] else [] 
  in
    [{conditions = LocationEmpty, loc = (curX,curY+moveDir)}]
      |> List.append additionalMoveLoc
