module Main where

import ElmTest exposing (..)
import Graphics.Element exposing (Element)

--These kinds of tests would be imported from other modules
fakeTests : Test
fakeTests =
  suite "Example Text"
    [ test "does math correctly" <|
        (1 + 1) `assertEqual` 2

    , test "does not miscalculate things" <|
        (2 + 2) `assertNotEqual` 5

    , test "exemplifies more complex test cases" <|
        let
          expression = 2 + 2
        in
          expression `assertEqual` 4
    ]


allTests : Test
allTests =
  suite "All tests"
    [ fakeTests
    ]

main : Element
main =
  elementRunner allTests
