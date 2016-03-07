module App.Components.Chessboard.View (..) where

import Array exposing (Array)
import Color exposing (Color)
import Graphics.Element exposing (Element)
import Graphics.Collage exposing (collage)
import App.Components.Chessboard.Actions exposing (..)
import App.Components.Chessboard.Model exposing (..)

squareSize = 60
squareSizeDiv2 = squareSize / 2
boardSize = squareSize * 8
boardSizeDiv2 = boardSize / 2

view : Signal.Address Action -> Chessboard -> Element
view address chessboard =
  Array.indexedMap (\x col -> Array.indexedMap (\y square -> getPieceForm (x,y) square) col) chessboard.squares
    |> getPieceFormsAsFlatList
    |> collage boardSize boardSize 

getPieceFormsAsFlatList: Array (Array Graphics.Collage.Form) -> List Graphics.Collage.Form
getPieceFormsAsFlatList arrayOfArraysOfForms =
  Array.foldl (\col flatList -> List.append flatList (Array.toList col)) [] arrayOfArraysOfForms

getPieceForm : (Int, Int) -> BoardSquare -> Graphics.Collage.Form
getPieceForm squarePos square =
  Graphics.Collage.square squareSize
    |> Graphics.Collage.filled (getSquareColor squarePos) 
    |> Graphics.Collage.move (translateToScreenCoordinates squarePos)

translateToScreenCoordinates : (Int, Int) -> (Float, Float)
translateToScreenCoordinates (xPos,yPos) =
  let
    x = toFloat xPos * squareSize
    y = toFloat yPos * squareSize
  in
    (x - boardSizeDiv2 + squareSizeDiv2, boardSizeDiv2 - y - squareSizeDiv2)

getSquareColor: (Int, Int) -> Color
getSquareColor (x,y) =
  if (x + y) % 2 == 0 then Color.white else Color.black
