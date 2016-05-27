module TestRunner exposing (main)

import App.Chessboard.Tests
import App.TestExtensions.AdditionalAssertionsTests

import ElmTest exposing (..)

allTests : Test
allTests =
  suite "All tests"
    [ App.Chessboard.Tests.tests
      , App.TestExtensions.AdditionalAssertionsTests.tests
    ]

main : Program Never
main =
  runSuiteHtml allTests
