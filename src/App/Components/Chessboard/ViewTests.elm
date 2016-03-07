module App.Components.Chessboard.ViewTests(tests) where

import App.Components.Chessboard.View exposing (..)
import Color

import ElmTest exposing (..)

tests : Test
tests =
  suite "View Tests"
    [ suite "Should be able to getSquareColor"
      [
        test "(0,0) -> white" <|
          getSquareColor (0,0) `assertEqual` Color.white
        , test "(1,0) -> black" <|
          getSquareColor (1,0) `assertEqual` Color.black
        , test "(0,1) -> black" <|
          getSquareColor (0,1) `assertEqual` Color.black
        , test "(1,3) -> white" <|
          getSquareColor (1,3) `assertEqual` Color.white
      ]
    ]
