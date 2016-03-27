module App.Chessboard.Tests (tests) where

import Array exposing (Array)
import App.Chessboard.Model exposing (..)
import App.Chessboard.View exposing (..)
import Color

import App.TestExtensions.AdditionalAssertions exposing (assertContainsOnly)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Chessboard Tests"
    [ viewTests
      , modelTests
    ]

viewTests : Test
viewTests =
  suite "View Tests"
    [ testsForGetSquareColor
      , testsForViewMarkDrawableSquareAsSelected
      , canConvertFromPosAndSquareToDrawableSquare
      , canConvertFromBoardPositionToScreenCoordinates
    ]


testsForGetSquareColor =
  suite "Should be able to getSquareColor"
    [ test "(0,0) -> white" <|
        Color.white `assertEqual` getSquareColor (0,0)
      , test "(1,0) -> charcoal" <|
        Color.charcoal `assertEqual` getSquareColor (1,0)
      , test "(0,1) -> charcoal" <|
        Color.charcoal `assertEqual` getSquareColor (0,1)
      , test "(1,3) -> white" <|
        Color.white `assertEqual` getSquareColor (1,3)
    ]

testDrawableSquare: DrawableSquare
testDrawableSquare = {
    boardPosition = (0,0)
    , square = FilledWith White Pawn
    , color = Color.white
  }

testsForViewMarkDrawableSquareAsSelected =
  suite "Can change color of Drawable Squares if Selected"
    [ test "Nothing should return original square" <|
        testDrawableSquare `assertEqual` (ifDrawableSquareSelectedChangeColor Nothing testDrawableSquare)
      , test "Different board position should return original square" <|
        testDrawableSquare `assertEqual` (ifDrawableSquareSelectedChangeColor (Just (1,1)) testDrawableSquare)
      , test "Same board position should return original square but with lightYellow color" <|
        { testDrawableSquare | color = Color.lightYellow } 
        `assertEqual` 
        (ifDrawableSquareSelectedChangeColor (Just (0,0)) testDrawableSquare)
      , test "Same board position but Empty square should return original square" <|
        { testDrawableSquare | square = Empty} 
        `assertEqual`
        (ifDrawableSquareSelectedChangeColor (Just (0,0)) { testDrawableSquare | square = Empty}) 
    ]
 
canConvertFromPosAndSquareToDrawableSquare =
  test "Can convert from position and square to DrawableSquare" <|
    testDrawableSquare
    `assertEqual`
    convertSquareToDrawableSquare (0,0) (FilledWith White Pawn)

canConvertFromBoardPositionToScreenCoordinates =
  test "Can convert from board position and square to screen coordinates" <| 
    (200, 500) `assertEqual` translateToScreenCoordinates 100 (2,5)


modelTests : Test
modelTests =
  suite "Model Tests"
    [ testMoveLocationsForEmptySquare
      , testMoveLocationsForPawnFilledSquare
    ]

testMoveLocationsForEmptySquare =
  test "Should be no possible move locations for an Empty Square" <| 
    [] `assertEqual` getPossibleMoveLocations (2,5) initialBoard.squares

testMoveLocationsForPawnFilledSquare =
  suite "Pawn should move correctly"
  [ test "Should be able to move one space or two on first move" <|
      [(0,2), (0,3)] `assertContainsOnly` (getPossibleMoveLocations (0,1) initialBoard.squares)
    , test "Should only be able to move one space after first move" <|
      [(0,3)] `assertContainsOnly`
      getPossibleMoveLocations (0,2) (getChessboardWithGivenSquares [((0,2), (FilledWith White Pawn))])
    , test "Should be able to take opposing pieces in diagonal positions" <|
      [(2,3),(0,3)] `assertContainsOnly`
      getPossibleMoveLocations (1,2) 
        (getChessboardWithGivenSquares [
          ((1,2), (FilledWith White Pawn))
          , ((2,3), (FilledWith Black Pawn))
          , ((0,3), (FilledWith Black Rook))
          , ((1,3), (FilledWith Black Bishop))])
    , test "Cannot move off of board" <|
      [] `assertContainsOnly`
      getPossibleMoveLocations (0,7) (getChessboardWithGivenSquares [((0,7), (FilledWith White Pawn))])
    , test "Should move up if on Black team" <|
      [(0,4)] `assertContainsOnly`
      getPossibleMoveLocations (0,5) (getChessboardWithGivenSquares [((0,5), (FilledWith Black Pawn))])
  ]

getChessboardWithGivenSquares: List ((Int,Int), BoardSquare) -> Chessboard
getChessboardWithGivenSquares squaresToSet =
  getEmptyChessboard
    |> updateChessboardWithGivenSquares squaresToSet

updateChessboardWithGivenSquares: List ((Int,Int), BoardSquare) -> Chessboard -> Chessboard
updateChessboardWithGivenSquares squaresToSet squares =
  List.foldl (\(loc, square) squares -> setPieceAtLoc loc square squares) squares squaresToSet 

getEmptyChessboard: Chessboard
getEmptyChessboard = Array.repeat 8 (Array.repeat 8 Empty)

setPieceAtLoc: (Int,Int) -> BoardSquare -> Chessboard -> Chessboard
setPieceAtLoc (x,y) squareToSet squares =
  let
    newRow = 
      Array.get y squares
        |> Maybe.map (Array.set x squareToSet)
  in
    case newRow of
      Nothing -> squares
      Just row -> Array.set y row squares 
