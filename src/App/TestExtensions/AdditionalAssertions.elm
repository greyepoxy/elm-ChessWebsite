module App.TestExtensions.AdditionalAssertions (assertContainsOnly, assertContainsOnlyFailureString) where

import ElmTest exposing (..)

assertContainsOnlyFailureString: List a -> List b -> String
assertContainsOnlyFailureString expectedItems actualItems =
  ("Expected list to contain: '" ++ (toString expectedItems) ++ 
  "' but it actually contained: '" ++ (toString actualItems) ++ "'")

assertContainsOnly: List a -> List a -> ElmTest.Assertion
assertContainsOnly expectedItems actualItems =
  if (containsOnly expectedItems actualItems)
    then ElmTest.pass
    else ElmTest.fail
      (assertContainsOnlyFailureString expectedItems actualItems)

containsOnly: List a -> List a -> Bool
containsOnly expectedItems actualItems =
  if (List.length expectedItems) == (List.length actualItems)
    then
      expectedItems
        |> List.map (\a -> List.member a actualItems)
        |> List.foldl (\a b -> a && b) True
    else
      False
