module App.Chessboard.Model (
  Team(White,Black)
  , ChessPiece(King,Queen,Rook,Bishop,Knight,Pawn)
  , BoardSquare(Empty,FilledWith)
  , Row, Chessboard, InteractiveChessboard, initialBoard, getPossibleMoveLocations) where

import Array exposing (Array)

type Team
  = White
  | Black

type ChessPiece
  = King
  | Queen
  | Rook
  | Bishop
  | Knight
  | Pawn


type BoardSquare
  = Empty
  | FilledWith Team ChessPiece

type alias Row = Array BoardSquare

type alias Chessboard = Array Row

type alias InteractiveChessboard = {
    squares: Array Row
    , selectedSquareLoc: Maybe (Int,Int)
  }

initialBoard : InteractiveChessboard
initialBoard = {
    squares = Array.fromList [
      getInitialTopOrBottomRow White
      , Array.repeat 8 (FilledWith White Pawn)
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 (FilledWith Black Pawn)
      , getInitialTopOrBottomRow Black
    ]
    , selectedSquareLoc = Nothing
  }

getInitialTopOrBottomRow : Team -> Array BoardSquare
getInitialTopOrBottomRow team = Array.fromList [
    FilledWith team Rook
    , FilledWith team Knight
    , FilledWith team Bishop
    , FilledWith team Queen
    , FilledWith team King
    , FilledWith team Bishop
    , FilledWith team Knight
    , FilledWith team Rook
  ]

type alias BoardSquareWithLoc = {
    boardPosition: (Int,Int)
    , square: BoardSquare
  }

{--
  Get every possible move location for a given board square
  at the given location in the given chessboard. 
--}
getPossibleMoveLocations: (Int,Int) -> Chessboard -> List (Int, Int)
getPossibleMoveLocations testLoc board =
  let
    maybeSquare = getBoardSquareAtLocation testLoc board
    moveLocs = 
      case maybeSquare of
        Nothing -> []
        Just square -> case square of
          Empty -> []
          FilledWith team piece ->
            case piece of
              Pawn -> getIdealPawnMoveLocations team testLoc
                |> List.filter (isValidMoveLocForPieceOfTeam team board)
              Rook -> getIdealRookMoveLocations testLoc
                |> List.filter (isValidMoveLocForPieceOfTeam team board)
              _ -> []
  in
    moveLocs
      |> List.map (\moveLoc -> moveLoc.loc)

getBoardSquareAtLocation: (Int,Int) -> Chessboard -> Maybe BoardSquare
getBoardSquareAtLocation (x,y) board =
  Array.get y board
    `Maybe.andThen` Array.get x

type CanMoveIf = 
  LocationEmptyOrContainsOpponentAndGivenLocationsAreEmpty (List (Int, Int))
  | LocationEmptyAndGivenLocationsAreEmpty (List (Int, Int))
  | LocationEmpty
  | LocationContainsOpponent

type alias MoveLoc = {
    conditions: CanMoveIf
    , loc: (Int, Int)
  }
 
isValidMoveLocForPieceOfTeam: Team -> Chessboard -> MoveLoc -> Bool
isValidMoveLocForPieceOfTeam movingPiecesTeam board {conditions, loc} =
  let
    maybeBoardSquareAtLoc = getBoardSquareAtLocation loc board
  in
    case conditions of
      LocationEmpty -> maybeBoardSquareAtLoc == Just Empty
      LocationContainsOpponent -> 
        case maybeBoardSquareAtLoc of
          Just (FilledWith team _) -> movingPiecesTeam /= team
          _ -> False
      LocationEmptyOrContainsOpponentAndGivenLocationsAreEmpty locsThatNeedToBeEmpty ->
        case maybeBoardSquareAtLoc of
          Just Empty -> areGivenLocsEmpty board locsThatNeedToBeEmpty
          Just (FilledWith team _) -> movingPiecesTeam /= team && (areGivenLocsEmpty board locsThatNeedToBeEmpty)
          Nothing -> False
      LocationEmptyAndGivenLocationsAreEmpty locsThatNeedToBeEmpty ->
        case maybeBoardSquareAtLoc of
          Just Empty -> areGivenLocsEmpty board locsThatNeedToBeEmpty
          _ -> False

areGivenLocsEmpty: Chessboard -> List (Int,Int) -> Bool
areGivenLocsEmpty board locs =
  List.map (\loc -> (getBoardSquareAtLocation loc board) == Just Empty) locs
    |> List.foldl (&&) True

getIdealPawnMoveLocations: Team -> (Int,Int) -> List MoveLoc
getIdealPawnMoveLocations team (curX,curY) =
  let
    moveDir = if team == White then 1 else -1
    atStartLoc = case team of
      White -> if curY == 1 then True else False
      Black -> if curY == 6 then True else False
    additionalMoveLoc = if atStartLoc 
      then [{
          conditions = LocationEmptyAndGivenLocationsAreEmpty [
            (curX,curY+moveDir)
          ]
          , loc = (curX,curY+2*moveDir)
        }] 
      else [] 
  in
    [{conditions = LocationEmpty, loc = (curX,curY+moveDir)}
      , {conditions = LocationContainsOpponent, loc = (curX+1,curY+moveDir)}
      , {conditions = LocationContainsOpponent, loc = (curX-1,curY+moveDir)}
    ]
      |> List.append additionalMoveLoc

getIdealRookMoveLocations: (Int,Int) -> List MoveLoc
getIdealRookMoveLocations startLoc =
  getMoveLocsInDirection startLoc Left
  ++
  getMoveLocsInDirection startLoc Right
  ++
  getMoveLocsInDirection startLoc Up
  ++
  getMoveLocsInDirection startLoc Down


type Direction =
  Up
  | Down
  | Left
  | Right
  
getMoveLocsInDirection: (Int,Int) -> Direction -> List MoveLoc
getMoveLocsInDirection startLoc direction =
  let
    moveDistances = [1,2,3,4,5,6,7]
  in
    List.map (getMoveLocForDirection startLoc direction moveDistances) moveDistances

getMoveLocForDirection: (Int,Int) -> Direction -> List Int -> Int -> MoveLoc
getMoveLocForDirection startLoc direction allDistances distance = 
  let
    loc = getLocWithDeltaAddedInDirection startLoc direction distance
    inBetweenLocs =
      List.filter (\d -> d < distance) allDistances
        |> List.map (getLocWithDeltaAddedInDirection startLoc direction)
  in
    { conditions = (LocationEmptyOrContainsOpponentAndGivenLocationsAreEmpty inBetweenLocs)
      , loc = loc
    }

getLocWithDeltaAddedInDirection: (Int,Int) -> Direction -> Int -> (Int,Int)
getLocWithDeltaAddedInDirection (startX, startY) direction distance =
  case direction of
    Up -> (startX, startY - distance)
    Down -> (startX, startY + distance)
    Left -> (startX - distance, startY)
    Right -> (startX + distance, startY)
