module Main where

import Components.FakeTests exposing (tests)

import ElmTest exposing (..)
import Graphics.Element exposing (Element)

allTests : Test
allTests =
  suite "All tests"
    [ tests
    ]

main : Element
main =
  elementRunner allTests
