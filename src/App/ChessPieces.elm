module App.ChessPieces exposing (..)

import Color exposing (Color)
import Color.Convert exposing (colorToHex)
import Svg exposing (..)
import Svg.Attributes exposing (..)

import App.Chessboard.Model exposing (Team(White, Black), ChessPiece(King, Queen, Bishop, Rook, Knight, Pawn))

defaultSize: number
defaultSize = 150

getScaleNumber : Int -> String
getScaleNumber squareSize = toString ((toFloat squareSize) / defaultSize)

getTransform : Int -> Svg.Attribute msg
getTransform squareSize =
  Svg.Attributes.transform ("scale(" ++ getScaleNumber squareSize ++ "," ++ getScaleNumber squareSize ++ ")")

-- to convert to white versions replace fill #fff and stroke "#000"
bishop : Int -> Team -> Svg msg
bishop squareSize team = 
  Svg.path [getTransform squareSize, d "M79.314 119.985c.008 1.87 0 3.645 0 5.44.003 6.244 12.488 15.194 18.794 15.25l39.178.095c-.152-2.583-4.918-7.636-7.824-7.75l-28.728-.114c-12.88-1.052-15.615-9.102-15.644-12.942zm-10.057 0c-.008 1.87 0 3.645 0 5.44-.002 6.244-12.487 15.194-18.794 15.25l-39.177.095c.152-2.583 4.917-7.636 7.823-7.75l28.727-.114c12.88-1.052 15.616-9.102 15.644-12.942zm27.095-19.695c.786 4.808 1.33 8.99 1.71 12.76l-47.148-.235c.08-3.993 1.414-8.437 2.38-12.663 14.73-4.318 29.253-5.014 43.058.138zM36.738 69.425c.028-8.406 7.43-21.84 36.732-41.588 1.103-.684 1.674-.725 2.718.028 11.74 9.73 35.323 24.923 35.66 41.17-.107 6.802-3.07 15.02-13.33 25.086-16.447-6.014-32.708-5.28-48.853-.096l-.002.036c-13.387-15.874-12.92-19.532-12.925-24.635zm43.608-55.26c0 3.12-2.727 5.65-6.092 5.65-3.364 0-6.092-2.53-6.092-5.65 0-3.12 2.728-5.65 6.092-5.65 3.365 0 6.092 2.53 6.092 5.65z" ] []
    |> getChessPieceSvg team

knight : Int -> Team -> Svg msg
knight squareSize team =
  Svg.path [getTransform squareSize, d "M39.287 137.905c1.294-12.7 5.822-30.038 24.367-37.106 5.5-2.1 8.384-12.178 12.85-16.283.975-.804.44-1.392 0-1.994-1.823-1.543-3.396-3.105-6.758-4.54-12.132-.702-24.288-3.258-36.22 11.74l-3.543-2.658 6.09-5.65-11.63-12.1-5.19 3.48.077-11.18 31.033-20.628.886-2.215c7.7-6.925 17.627-12.685 27.468-18.33l4.43-6.26c2.564 3.62 3.654 7.67 5.317 11.077C123.448 39.4 127.27 75.77 126.11 94.57c-2.524 34.38-1.562 34.89 1.067 43.388z" ] []
    |> getChessPieceSvg team

rook : Int -> Team -> Svg msg
rook squareSize team =
  Svg.path [getTransform squareSize, d "M46.62 47.6l-12.586-9.244-.692-19.406h11.31l-.11 12.184H69.63l-.056-12.184 11.923.022v12.06l24.122-.038-.08-11.983h12.062l-1.253 19.503-12.865 9.007zm62.056 63.777l12.634 10.134c1.434 1.055 1.22 7.898 1.227 12.24l-95.082.157c.456-4.272.024-11.56 1.37-12.805l13.08-9.908zM46.578 54.49l56.966-.39 4.18 50.688-65.094-.074z" ] []
    |> getChessPieceSvg team

queen : Int -> Team -> Svg msg
queen squareSize team = 
  Svg.path [getTransform squareSize, d "M113.21 104.393c.057-9.7 6.094-22.464 12.866-35.407L107.91 81.834 97.28 31.326l-22.66 46.547L51.644 30.44l-9.98 51.578-18.818-12.59c6.49 10.952 12.233 24.168 13.4 35.398 26.207-13.236 52.014-9.645 76.965-.433zM33.923 135l81.09-.022c-2.755-7.75-3.43-17.005-2.892-23.966-21.918-9.6-46.506-12.144-75.087.717.918 7.763.135 15.517-3.11 23.27zM145.35 52.596c0 3.18-2.58 5.76-5.76 5.76-3.182 0-5.76-2.58-5.76-5.76 0-3.18 2.578-5.76 5.76-5.76 3.18 0 5.76 2.58 5.76 5.76zm-40.32-33.672c0 3.18-2.577 5.76-5.758 5.76-3.18 0-5.76-2.58-5.76-5.76 0-3.18 2.58-5.76 5.76-5.76 3.18 0 5.76 2.58 5.76 5.76zm-48.956.222c0 3.18-2.578 5.76-5.76 5.76-3.18 0-5.76-2.58-5.76-5.76 0-3.18 2.58-5.76 5.76-5.76 3.182 0 5.76 2.58 5.76 5.76zm-39.652 33.45c0 3.18-2.58 5.76-5.76 5.76-3.18 0-5.76-2.58-5.76-5.76 0-3.18 2.58-5.76 5.76-5.76 3.18 0 5.76 2.58 5.76 5.76z" ] []
    |> getChessPieceSvg team

king : Int -> Team -> Svg msg
king squareSize team =
  Svg.path [getTransform squareSize, d "M72.05 102.66h.003c-.457-7.89-1.002-15.688-2.884-23.305-1.882-7.616-5.09-14.972-10.892-22.135-6.653-7.088-13.54-13.36-21.84-13.052-6.756-.122-26.664 7.65-26.695 27.16.16 11.06 5.717 22.687 25.034 40.322 13.92-6.093 26.3-8.597 37.273-8.99zm-38.16 39.48l83.408.064c-1.334-8.234-2.217-14.32-4.098-24.987-23.99-9.818-49.198-11-75.86.125-1.44 7.962-2.397 16.486-3.45 24.797zm107.384-70.872c-.274-13.166-13.702-26.698-26.74-27.183C106.028 44 100.203 48.84 93.17 55.97c-10.46 13.53-13.205 29.45-13.712 46.76 15.017.703 27.123 5.163 36.734 8.786 12.807-12.14 25.193-24.83 25.084-40.248zm-65.72 8.513c-2.13-11.064-6.938-18.917-11.674-26.518 3.145-4.453 5.894-7.646 9.055-10.03 1.485-1.01 3.813-.983 5.09-.08 3.65 2.783 6.736 6.19 9.21 9.855-6.043 7.48-9.466 16.638-11.68 26.774zM71.212 7.36v8.85h-9.164v7.91l9.007-.078v12.923h8.067V24.277l10.025-.078V16.13h-9.79l-.078-8.85z" ] []
    |> getChessPieceSvg team

pawn : Int -> Team -> Svg msg
pawn squareSize team =
  Svg.path [getTransform squareSize, d "M65.282 73.664l16.84-.078c1.366 19.713 7.856 36.04 23.81 47.854 8.544 6.488 10.888 10.25 11.277 14.41l-86.937-.155c.157-4.81 4.672-8.857 12.06-15.038 18.13-14.7 21.3-29.542 22.95-46.993zm4.207-21.468L50.792 68.103l45.27-.078-17.7-15.93c-3.29.86-5.474.9-8.874.102zm20.268-15.064c0 8.625-7.14 15.618-15.95 15.618-8.808 0-15.95-6.993-15.95-15.618S65 21.515 73.81 21.515c8.81 0 15.95 6.992 15.95 15.617z" ] []
    |> getChessPieceSvg team

getChessPieceSvg: Team -> Svg msg -> Svg msg
getChessPieceSvg team path =
  let
    (fillColor, strokeColor) =  getColorFromTeam team
  in
    g [ stroke (colorToHex strokeColor)
      , fill (colorToHex fillColor)
      , pointerEvents "none" ]
    [ path ]

-- get the (fill, stroke) colors based on the players team
getColorFromTeam: Team -> (Color, Color)
getColorFromTeam team =
  if team == White then (Color.white, Color.black) else (Color.black, Color.white)

getPieceAsSvg: Int -> Team -> ChessPiece -> Svg msg
getPieceAsSvg squareSize team piece =
  case piece of
    King -> king squareSize team
    Queen -> queen squareSize team
    Rook -> rook squareSize team
    Bishop -> bishop squareSize team
    Knight -> knight squareSize team
    Pawn -> pawn squareSize team
