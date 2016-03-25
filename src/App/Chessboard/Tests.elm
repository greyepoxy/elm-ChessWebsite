module App.Chessboard.Tests (tests) where

import App.Chessboard.Model exposing (..)
import App.Chessboard.View exposing (..)
import Color

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
        getSquareColor (0,0) `assertEqual` Color.white
      , test "(1,0) -> charcoal" <|
        getSquareColor (1,0) `assertEqual` Color.charcoal
      , test "(0,1) -> charcoal" <|
        getSquareColor (0,1) `assertEqual` Color.charcoal
      , test "(1,3) -> white" <|
        getSquareColor (1,3) `assertEqual` Color.white
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
        (markDrawableSquareAsSelected Nothing testDrawableSquare) `assertEqual` testDrawableSquare
      , test "Different board position should return original square" <|
        (markDrawableSquareAsSelected (Just (1,1)) testDrawableSquare) `assertEqual` testDrawableSquare
      , test "Same board position should return original square selected" <|
        (markDrawableSquareAsSelected (Just (0,0)) testDrawableSquare) 
        `assertEqual` 
        { testDrawableSquare | selected = True }
      , test "Same board position but Empty square should return original square" <|
        (markDrawableSquareAsSelected (Just (0,0)) { testDrawableSquare | square = Empty}) 
        `assertEqual` 
        { testDrawableSquare | square = Empty}
    ]
 
canConvertFromPosAndSquareToDrawableSquare =
  test "Can convert from position and square to DrawableSquare" <|
    convertSquareToDrawableSquare (0,0) (FilledWith White Pawn)
    `assertEqual`
    testDrawableSquare

canConvertFromBoardPositionToScreenCoordinates =
  test "Can convert from board position and square to screen coordinates" <|
  translateToScreenCoordinates 100 (2,5) `assertEqual` (200, 500)


modelTests : Test
modelTests =
  suite "Model Tests"
    [ 
    ]

