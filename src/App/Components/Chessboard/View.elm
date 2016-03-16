module App.Components.Chessboard.View (..) where

import Array exposing (Array)
import Color exposing (Color)
import Color.Convert exposing (colorToHex)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import App.Components.Chessboard.Actions exposing (..)
import App.Components.Chessboard.Model exposing (..)

squareSize = 150
squareSizeDiv2 = squareSize / 2
boardSize = squareSize * 8
boardSizeDiv2 = boardSize / 2

view : Signal.Address Action -> Chessboard -> Html
view address chessboard =
  Array.indexedMap (\x col -> Array.indexedMap (\y square -> getSquareAsSvg (x,y) square) col) chessboard.squares
    |> getArrayOfArraysAsFlatList
    |> Svg.svg [width (toString boardSize), height (toString boardSize)]

getArrayOfArraysAsFlatList: Array (Array b) -> List b
getArrayOfArraysAsFlatList arrayOfArrays =
  Array.foldl (\col flatList -> List.append flatList (Array.toList col)) [] arrayOfArrays

translateToScreenCoordinates : (Int, Int) -> (Float, Float)
translateToScreenCoordinates (squareX, squareY) =
  let
    x = toFloat squareX * squareSize
    y = toFloat squareY * squareSize
  in
    (x, y)

getSquareColor: (Int, Int) -> Color
getSquareColor (x,y) =
  if (x + y) % 2 == 0 then Color.white else Color.black  

getSquareAsSvg: (Int, Int) -> BoardSquare -> Svg
getSquareAsSvg squarePos square =
  let
    (xPos, yPos) = translateToScreenCoordinates squarePos
  in
    Svg.rect [x (toString xPos)
      , y (toString yPos)
      , width (toString squareSize)
      , height (toString squareSize)
      , fill (colorToHex (getSquareColor squarePos))] []
