module App.Chessboard.View (..) where

import Array exposing (Array)
import Color exposing (Color)
import Color.Convert exposing (colorToHex)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseDown, onMouseUp, onMouseMove, onClick)
import App.Chessboard.Actions exposing (..)
import App.Chessboard.Model exposing (..)
import App.ChessPieces as ChessPieces

type alias DrawableSquare = {
  boardPosition: (Int, Int)
  , square: BoardSquare
  , color: Color
}

indexedMap: ((Int, Int)-> b -> a) -> Array (Array b) -> Array (Array a)
indexedMap funcToMap items =
  Array.indexedMap (\y col -> Array.indexedMap (\x item -> funcToMap (x,y) item) col) items

getArrayOfArraysAsFlatList: Array (Array b) -> List b
getArrayOfArraysAsFlatList arrayOfArrays =
  Array.foldl (\col flatList -> List.append flatList (Array.toList col)) [] arrayOfArrays

view : Signal.Address Action -> InteractiveChessboard -> Html
view address chessboard =
  let 
    squareSize = 150
    boardSize = squareSize * (Array.length chessboard.squares)
  in
    indexedMap convertSquareToDrawableSquare chessboard.squares
      |> getArrayOfArraysAsFlatList
      |> List.map (ifSelectedChangeColor chessboard.selectedSquareLoc)
      |> List.map 
        (ifAPossibleMoveLocationChangeColor 
          (getPossibleMoveLocs chessboard.squares chessboard.selectedSquareLoc))
      |> List.map (getSquareAsSvg squareSize address)
      |> Svg.svg [class "mx-auto"
        , preserveAspectRatio "xMidYMid meet"  
        , width "100%"
        , height "100%"
        , viewBox ("0 0 " ++ (toString boardSize) ++ " " ++ (toString boardSize))
        ]

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

convertSquareToDrawableSquare: (Int, Int) -> BoardSquare -> DrawableSquare
convertSquareToDrawableSquare pos square = {
    boardPosition = pos
    , square = square
    , color = (getSquareColor pos)
  }

getPossibleMoveLocs: Chessboard -> Maybe (Int, Int) -> List (Int, Int)
getPossibleMoveLocs board selectedSquare =
  Maybe.map (\loc -> getPossibleMoveLocations loc board) selectedSquare
    |> Maybe.withDefault []

ifAPossibleMoveLocationChangeColor: List (Int, Int) -> DrawableSquare -> DrawableSquare
ifAPossibleMoveLocationChangeColor possibleMoveLocs original =
  if List.member original.boardPosition possibleMoveLocs
    then { original | color = Color.lightGreen }
    else original

ifSelectedChangeColor: Maybe (Int, Int) -> DrawableSquare -> DrawableSquare
ifSelectedChangeColor selectedSquare original =
  case original.square of
    Empty -> original
    FilledWith team _ ->
      if (doPositionsMatch selectedSquare original.boardPosition) 
        then { original | color = Color.lightYellow }
        else original

doPositionsMatch: Maybe (Int, Int) -> (Int,Int) -> Bool
doPositionsMatch maybePos (x,y) =
  case maybePos of
    Nothing -> False
    Just (xPos, yPos) -> x == xPos && y == yPos 

getSquareAsSvg: Int -> Signal.Address Action -> DrawableSquare -> Svg
getSquareAsSvg squareSize address drawableSquare =
  let
    (xPos, yPos) = translateToScreenCoordinates squareSize drawableSquare.boardPosition
  in
    Svg.g [
      transform ("translate(" ++ (toString xPos) ++ "," ++ (toString yPos) ++ ")")
    ]
    [ 
      Svg.rect [ 
        width (toString squareSize)
        , height (toString squareSize)
        , fill (colorToHex drawableSquare.color)
        , onClick (Signal.message address (SelectLocation drawableSquare.boardPosition))
      ] []
      , getBoardSquareAsSvg squareSize drawableSquare.square
    ]

getBoardSquareAsSvg: Int -> BoardSquare -> Svg
getBoardSquareAsSvg squareSize square =
  case square of
    Empty -> g [] []
    FilledWith team piece -> ChessPieces.getPieceAsSvg squareSize team piece
