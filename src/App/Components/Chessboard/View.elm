module App.Components.Chessboard.View (..) where

import Array exposing (Array)
import Color exposing (Color)
import Color.Convert exposing (colorToHex)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import App.Components.Chessboard.Actions exposing (..)
import App.Components.Chessboard.Model exposing (..)
import App.Components.ChessPieces as ChessPieces

numSquares = 8

view : Signal.Address Action -> Chessboard -> Html
view address chessboard =
  let 
    squareSize = 150
    boardSize = squareSize * numSquares
  in
    Array.indexedMap (\y col -> Array.indexedMap (\x square -> getSquareAsSvg squareSize (x,y) square) col) chessboard.squares
      |> getArrayOfArraysAsFlatList
      |> Svg.svg [class "mx-auto"
        , preserveAspectRatio "xMidYMid meet"  
        , width "100%"
        , height "100%"
        , viewBox ("0 0 " ++ (toString boardSize) ++ " " ++ (toString boardSize))]

getArrayOfArraysAsFlatList: Array (Array b) -> List b
getArrayOfArraysAsFlatList arrayOfArrays =
  Array.foldl (\col flatList -> List.append flatList (Array.toList col)) [] arrayOfArrays

translateToScreenCoordinates : Int -> (Int, Int) -> (Int, Int)
translateToScreenCoordinates squareSize (squareX, squareY) =
  let
    x = squareX * squareSize
    y = squareY * squareSize
  in
    (x, y)

getSquareColor: (Int, Int) -> Color
getSquareColor (x,y) =
  if (x + y) % 2 == 0 then Color.white else Color.charcoal

getSquareAsSvg: Int -> (Int, Int) -> BoardSquare -> Svg
getSquareAsSvg squareSize squarePos square =
  let
    (xPos, yPos) = translateToScreenCoordinates squareSize squarePos
  in
    Svg.g [
      transform ("translate(" ++ (toString xPos) ++ "," ++ (toString yPos) ++ ")")
    ]
    [ 
      Svg.rect [ 
        width (toString squareSize)
        , height (toString squareSize)
        , fill (colorToHex (getSquareColor squarePos))
      ] []
      , getBoardSquareAsSvg squareSize square
    ]

getBoardSquareAsSvg: Int -> BoardSquare -> Svg
getBoardSquareAsSvg squareSize square =
  case square of
    Empty -> g [] []
    FilledWith team piece -> ChessPieces.getPieceAsSvg squareSize team piece
