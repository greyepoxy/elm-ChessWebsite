module App.Chessboard.Tests exposing (tests)

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
        testDrawableSquare `assertEqual` (ifSelectedChangeColor Nothing testDrawableSquare)
      , test "Different board position should return original square" <|
        testDrawableSquare `assertEqual` (ifSelectedChangeColor (Just (1,1)) testDrawableSquare)
      , test "Same board position should return original square but with lightYellow color" <|
        { testDrawableSquare | color = Color.lightYellow } 
        `assertEqual` 
        (ifSelectedChangeColor (Just (0,0)) testDrawableSquare)
      , test "Same board position but Empty square should return original square" <|
        { testDrawableSquare | square = Empty} 
        `assertEqual`
        (ifSelectedChangeColor (Just (0,0)) { testDrawableSquare | square = Empty}) 
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
      , testMoveLocationsForRookFilledSquare
      , testMoveLocationsForKnightFilledSquare
      , testMoveLocationsForBishopFilledSquare
      , testMoveLocationsForQueenFilledSquare
      , testMoveLocationsForKingFilledSquare
      , testMoveLocationsForWhenKingIsInCheck
    ]

testMoveLocationsForEmptySquare =
  test "Should be no possible move locations for an Empty Square" <| 
    [] `assertEqual` getPossibleMoveLocations (2,5) initialBoard.gameState.board

testMoveLocationsForPawnFilledSquare =
  suite "Pawn should move correctly"
  [ test "Should be able to move one space or two on first move" <|
      [(0,2), (0,3)] `assertContainsOnly` (getPossibleMoveLocations (0,1) initialBoard.gameState.board)
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
    , test "Should be able to move only one space on first move if piece in the way" <|
      [(0,2)] `assertContainsOnly` 
      getPossibleMoveLocations (0,1) 
        (getChessboardWithGivenSquares [((0,1), FilledWith White Pawn),((0,3), FilledWith Black Pawn)])
  ]
  
testMoveLocationsForRookFilledSquare =
  suite "Rook should move correctly"
  [ test "Should be able to slide in a vertical or horizontal direction." <|
      [(0,3),(1,3),(2,3),(4,3),(5,3),(6,3),(7,3),(3,0),(3,1),(3,2),(3,4),(3,5),(3,6),(3,7)]
      `assertContainsOnly`
      getPossibleMoveLocations (3,3) (getChessboardWithGivenSquares [((3,3), (FilledWith White Rook))])
    , test "Should be able to take opposing player piece but not a friendly one." <|
      [(1,0)]
      `assertContainsOnly`
      getPossibleMoveLocations (0,0) 
        (getChessboardWithGivenSquares [
          ((0,0), FilledWith White Rook)
          ,((1,0), FilledWith Black Bishop)
          ,((0,1), FilledWith White Bishop)])
  ]
  
testMoveLocationsForKnightFilledSquare =
  suite "Knight should move correctly"
  [ test "Should be able to move to locations at L's from start location." <|
      [(5,2),(5,4),(1,2),(2,5),(4,5),(2,1),(2,5)]
      `assertContainsOnly`
      getPossibleMoveLocations (3,3) 
        (getChessboardWithGivenSquares [
          ((3,3), FilledWith White Knight)
          ,((5,4), FilledWith Black Pawn)
          ,((1,4), FilledWith White Pawn)])
    , test "Can jump over pieces." <|
      [(0,2),(2,2)]
      `assertContainsOnly`
      getPossibleMoveLocations (1,0) initialBoard.gameState.board
  ]

testMoveLocationsForBishopFilledSquare =
  suite "Bishop should move correctly"
  [ test "Should be able to slide to any location diagonally." <|
      [(2,2),(1,1),(0,0),(4,4),(5,5),(6,6),(7,7),(4,2),(5,1),(6,0),(2,4),(1,5),(0,6)]
      `assertContainsOnly`
      getPossibleMoveLocations (3,3) (getChessboardWithGivenSquares [((3,3), FilledWith White Bishop)])
    , test "Should be able to take opposing player piece but not a friendly one." <|
      [(0,1)]
      `assertContainsOnly`
      getPossibleMoveLocations (1,0) 
        (getChessboardWithGivenSquares [
          ((1,0), FilledWith White Bishop)
          ,((0,1), FilledWith Black Rook)
          ,((2,1), FilledWith White Pawn)])
  ]

testMoveLocationsForQueenFilledSquare =
  suite "Queen should move correctly"
  [ test "should be able to slid around like bishop and rook." <|
      [(3,2),(2,1),(0,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0)]
      `assertContainsOnly`
      getPossibleMoveLocations (1,0)
        (getChessboardWithGivenSquares [
          ((1,0), FilledWith White Queen)
          ,((0,1), FilledWith White Rook)
          ,((1,1), FilledWith White Pawn)
          ,((3,2), FilledWith Black Pawn)
        ])
  ]

testMoveLocationsForKingFilledSquare =
  suite "King should move correctly"
  [ test "should be able to move one square in any direction." <|
      [(2,2),(3,2),(4,2),(4,3),(4,4),(3,4),(2,4),(2,3)]
      `assertContainsOnly`
      getPossibleMoveLocations (3,3) (getChessboardWithGivenSquares [((3,3), FilledWith White King)])
  ]
  
testMoveLocationsForWhenKingIsInCheck =
  suite "When King is in check"
  [ test "should only allow moves that do not put player king into check." <|
      []
      `assertContainsOnly`
      getPossibleMoveLocations (1,1) 
        (getChessboardWithGivenSquares [
          ((0,0), FilledWith White King)
          ,((1,1), FilledWith White Pawn)
          ,((3,3), FilledWith Black Bishop)
        ])
    , test "should not be allowed to move into check." <|
      [(0,1)]
      `assertContainsOnly`
      getPossibleMoveLocations (0,0) 
        (getChessboardWithGivenSquares [
          ((0,0), FilledWith White King)
          ,((1,1), FilledWith White Pawn)
          ,((2,1), FilledWith Black Bishop)
        ])
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
