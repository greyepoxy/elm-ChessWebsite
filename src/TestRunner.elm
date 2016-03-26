module TestRunner where

import App.Chessboard.Tests
import App.TestExtensions.AdditionalAssertionsTests

import ElmTest exposing (..)
import Graphics.Element exposing (Element)

allTests : Test
allTests =
  suite "All tests"
    [ App.Chessboard.Tests.tests
      , App.TestExtensions.AdditionalAssertionsTests.tests
    ]

main : Element
main =
  elementRunner allTests
