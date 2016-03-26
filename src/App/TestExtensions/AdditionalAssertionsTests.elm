module App.TestExtensions.AdditionalAssertionsTests (tests) where

import App.TestExtensions.AdditionalAssertions exposing (..)
import ElmTest exposing (..)

tests : Test
tests =
  suite "AdditionalAssertionsTests"
    [ suite "assertContainsOnly Should Work"
        [ test "Should pass if list contain same items"
            <| assertEqual (ElmTest.pass) (assertContainsOnly [5,6,7] [5,7,6])
          , test "Should fail if actual list contains more/less items"
            <| assertEqual 
              (ElmTest.fail <| assertContainsOnlyFailureString [5,6] [5,6,7])
              (assertContainsOnly [5,6] [5,6,7])
          , test "Should fail if actual list contains different items"
            <| assertEqual 
              (ElmTest.fail <| assertContainsOnlyFailureString [5,6] [5,7]) 
              (assertContainsOnly [5,6] [5,7])
        ]
    ]
