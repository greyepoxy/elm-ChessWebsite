module TestRunner where

import App.Components.Chessboard.ViewTests

import ElmTest exposing (..)
import Graphics.Element exposing (Element)

allTests : Test
allTests =
  suite "All tests"
    [ App.Components.Chessboard.ViewTests.tests
    ]

main : Element
main =
  elementRunner allTests
