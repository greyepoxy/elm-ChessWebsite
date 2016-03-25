module App.Chessboard.Model (Team(White,Black), ChessPiece(King,Queen,Rook,Bishop,Knight,Pawn), BoardSquare(Empty,FilledWith), Row, Chessboard, initialBoard) where

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

