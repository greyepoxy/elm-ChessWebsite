module App.Components.Chessboard.Model (Team, ChessPiece, BoardSquare, Chessboard, initialBoard) where

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

type alias Chessboard = {
    squares: Array (Array BoardSquare)
  }

{--
Chess Board is represented by an array of arrays.
First array is column, second is row -> (x,y)
--}
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