module TestRunner where

import App.Chessboard.ViewTests

import ElmTest exposing (..)
import Graphics.Element exposing (Element)

allTests : Test
allTests =
  suite "All tests"
    [ App.Chessboard.ViewTests.tests
    ]

main : Element
main =
  elementRunner allTests
