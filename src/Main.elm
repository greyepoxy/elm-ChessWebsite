module Main exposing (..)

import Window
import Platform.Cmd exposing (Cmd)
import Html.App
import Platform.Cmd exposing (Cmd)
import App.Model exposing (initialModel, AppModel)
import App.Messages exposing (Message(Resize))
import App.Update exposing (update)
import App.View exposing (view)


main : Program Never
main =
   Html.App.program
    { init = init (0,0)
    , update = update
    , view = view
    , subscriptions = windowDimensions
    }

-- port initialWindowDimensions : (Int, Int)


init : (Int,Int) -> ( AppModel, Cmd Message )
init initialWindowDimensions =
  ( initialModel initialWindowDimensions, Cmd.none )

windowDimensions : AppModel -> Sub Message
windowDimensions model = 
  Window.resizes (\{height,width} -> Resize (width, height)) 