module App.Chessboard.View (..) where

import Array exposing (Array)
import Color exposing (Color)
import Color.Convert exposing (colorToHex)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseDown, onMouseUp, onMouseMove, onMouseOut)
import App.Chessboard.Actions exposing (..)
import App.Chessboard.Model exposing (..)
import App.ChessPieces as ChessPieces

numSquares = 8

view : Signal.Address Action -> Chessboard -> Html
view address chessboard =
  let 
    squareSize = 150
    boardSize = squareSize * numSquares
  in
    indexedMap (ifBoardSquareIsSelectedMarkAsEmpty chessboard.selectedSquareLoc) chessboard.squares
      |> indexedMap (getSquareAsSvg squareSize address)
      |> getArrayOfArraysAsFlatList
      |> Svg.svg [class "mx-auto"
        , preserveAspectRatio "xMidYMid meet"  
        , width "100%"
        , height "100%"
        , viewBox ("0 0 " ++ (toString boardSize) ++ " " ++ (toString boardSize))
        --, onMouseLeave (Signal.message address (StopMovingPieceAt Nothing))
        ]

indexedMap: ((Int,Int)-> BoardSquare -> a) -> Array Row -> Array (Array a)
indexedMap funcToMap squares =
  Array.indexedMap (\y col -> Array.indexedMap (\x square -> funcToMap (x,y) square) col) squares

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

ifBoardSquareIsSelectedMarkAsEmpty: Maybe (Int,Int) -> (Int, Int) -> BoardSquare -> BoardSquare
ifBoardSquareIsSelectedMarkAsEmpty selectedSquare (x,y) originalSquare =
  case originalSquare of
    Empty -> originalSquare
    FilledWith team piece ->
      case selectedSquare of
        Nothing -> originalSquare
        Just (x',y') ->
          if x == x' && y == y' then Empty else originalSquare

getSquareAsSvg: Int -> Signal.Address Action -> (Int, Int) -> BoardSquare -> Svg
getSquareAsSvg squareSize address squarePos square =
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
        , onMouseDown (Signal.message address (StartMovingPieceAt squarePos))
        , onMouseUp (Signal.message address (StopMovingPieceAt (Just squarePos)))
      ] []
      , getBoardSquareAsSvg squareSize square
    ]

getBoardSquareAsSvg: Int -> BoardSquare -> Svg
getBoardSquareAsSvg squareSize square =
  case square of
    Empty -> g [] []
    FilledWith team piece -> ChessPieces.getPieceAsSvg squareSize team piece
