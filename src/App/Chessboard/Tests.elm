module App.Chessboard.Tests (tests) where

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
    , selected = False
  }

testsForViewMarkDrawableSquareAsSelected =
  suite "Can mark Drawable Squares As Selected"
    [ test "Nothing should return original square" <|
        testDrawableSquare `assertEqual` (markDrawableSquareAsSelected Nothing testDrawableSquare)
      , test "Different board position should return original square" <|
        testDrawableSquare `assertEqual` (markDrawableSquareAsSelected (Just (1,1)) testDrawableSquare)
      , test "Same board position should return original square selected" <|
        { testDrawableSquare | selected = True } 
        `assertEqual` 
        (markDrawableSquareAsSelected (Just (0,0)) testDrawableSquare)
      , test "Same board position but Empty square should return original square" <|
        { testDrawableSquare | square = Empty} 
        `assertEqual`
        (markDrawableSquareAsSelected (Just (0,0)) { testDrawableSquare | square = Empty}) 
    ]
 
canConvertFromPosAndSquareToDrawableSquare =
  test "Can convert from position and square to DrawableSquare" <|
    testDrawableSquare
    `assertEqual`
    convertSquareToDrawableSquare (0,0) (FilledWith White Pawn)

canConvertFromBoardPositionToScreenCoordinates =
  test "Can convert from board position and square to screen coordinates"
    <| (200, 500) `assertEqual` translateToScreenCoordinates 100 (2,5)


modelTests : Test
modelTests =
  suite "Model Tests"
    [ testMoveLocationsForEmptySquare
      , testMoveLocationsForPawnFilledSquare
    ]

testMoveLocationsForEmptySquare =
  test "Should be no possible move locations for an Empty Square"
    <| [] `assertEqual` getPossibleMoveLocations initialBoard (2,5)

testMoveLocationsForPawnFilledSquare =
  suite "Pawn should move correctly"
  [ test "Should be able to move one space or two on first move"
      <| assertContainsOnly [(0,2), (0,3)] (getPossibleMoveLocations initialBoard (0,1))
  ]
