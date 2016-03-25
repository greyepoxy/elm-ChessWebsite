module TestRunner where

import App.Chessboard.Tests

import ElmTest exposing (..)
import Graphics.Element exposing (Element)

allTests : Test
allTests =
  suite "All tests"
    [ App.Chessboard.Tests.tests
    ]

main : Element
main =
  elementRunner allTests
