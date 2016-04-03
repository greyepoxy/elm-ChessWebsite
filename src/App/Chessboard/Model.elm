module App.Chessboard.Model (
  Team(White,Black)
  , ChessPiece(King,Queen,Rook,Bishop,Knight,Pawn)
  , BoardSquare(Empty,FilledWith)
  , indexedMap, getArrayOfArraysAsFlatList
  , Row, Chessboard, ChessGameState, InteractiveChessboard, initialBoard
  , setPieceAtLoc, tryMovePiece, getPossibleMoveLocations
  , getPossibleMoveLocationsForGameState, isPlayersTurnForPieceAtLocation) where

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

type alias ChessGameState = {
  board: Chessboard
  , totalMovesSoFar: Int
}

type alias InteractiveChessboard = {
    gameState: ChessGameState
    , selectedSquareLoc: Maybe (Int,Int)
  }

initialBoard : InteractiveChessboard
initialBoard = 
  let
    board = Array.fromList [
      getInitialTopOrBottomRow White
      , Array.repeat 8 (FilledWith White Pawn)
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 Empty
      , Array.repeat 8 (FilledWith Black Pawn)
      , getInitialTopOrBottomRow Black
    ]
  in {
    gameState = {
      board = board
      , totalMovesSoFar = 0 
    }
    , selectedSquareLoc = Nothing
  }

getInitialTopOrBottomRow : Team -> Array BoardSquare
getInitialTopOrBottomRow team = Array.fromList [
    FilledWith team Rook
    , FilledWith team Knight
    , FilledWith team Bishop
    , FilledWith team King
    , FilledWith team Queen
    , FilledWith team Bishop
    , FilledWith team Knight
    , FilledWith team Rook
  ]

type alias BoardSquareWithLoc = {
    boardPosition: (Int,Int)
    , square: BoardSquare
  }

indexedMap: ((Int, Int)-> b -> a) -> Array (Array b) -> Array (Array a)
indexedMap funcToMap items =
  Array.indexedMap (\y col -> Array.indexedMap (\x item -> funcToMap (x,y) item) col) items

getArrayOfArraysAsFlatList: Array (Array b) -> List b
getArrayOfArraysAsFlatList arrayOfArrays =
  Array.foldl (\col flatList -> List.append flatList (Array.toList col)) [] arrayOfArrays

getBoardWithPieceMoved: Chessboard -> (Int,Int) -> (Int,Int) -> Chessboard
getBoardWithPieceMoved board startLoc endLoc =
  let
    startBoardSquareIfExists = getBoardSquareAtLocation startLoc board
  in
    case startBoardSquareIfExists of
      Nothing -> board
      Just startBoardSquare ->
        case startBoardSquare of
          FilledWith team piece ->
            setPieceAtLoc endLoc startBoardSquare board
              |> setPieceAtLoc startLoc Empty
          Empty -> board

{--
  returns chessboard with piece at given location
--}
setPieceAtLoc: (Int,Int) -> BoardSquare -> Chessboard -> Chessboard
setPieceAtLoc (x,y) squareToSet squares =
  let
    newRow = 
      Array.get y squares
        |> Maybe.map (Array.set x squareToSet)
  in
    case newRow of
      Nothing -> squares
      Just row -> Array.set y row squares 

getBoardSquareAtLocation: (Int,Int) -> Chessboard -> Maybe BoardSquare
getBoardSquareAtLocation (x,y) board =
  Array.get y board
    `Maybe.andThen` Array.get x

getKingLocForPlayer: Team -> Chessboard -> Maybe (Int,Int)
getKingLocForPlayer playerTeam board =
  let
    mapFn loc square =
      case square of
        FilledWith team King -> if playerTeam == team then Just loc else Nothing
        _ -> Nothing
    foldFn maybeLoc lastLoc =
      case maybeLoc of
        Nothing -> lastLoc
        Just loc -> Just loc
  in
    indexedMap mapFn board
      |> getArrayOfArraysAsFlatList
      |> List.foldl foldFn Nothing

getAllPieceLocationsForTeam: Team -> Chessboard -> List (Int,Int)
getAllPieceLocationsForTeam playerTeam board =
  let
    mapFn loc square =
      case square of
        FilledWith team _ -> if playerTeam == team then Just loc else Nothing
        Empty -> Nothing
  in
    indexedMap mapFn board
      |> getArrayOfArraysAsFlatList
      |> List.filterMap identity

isPlayerKingInCheck: Team -> Chessboard -> Bool
isPlayerKingInCheck team board =
  let
    kingLoc = getKingLocForPlayer team board
  in
    case kingLoc of
      Nothing -> False
      Just loc ->
        let
          opposingPieceLocs = getAllPieceLocationsForTeam (if team == White then Black else White) board
        in
          List.map (getPossibleMoveLocationsNotValidatingForCheck board) opposingPieceLocs
            |> List.foldl (++) []
            |> List.map (\dangerLoc -> dangerLoc == loc)
            |> List.foldl (||) False

{--
  Determine if the given location contains a piece owned by the current player
--}
isPlayersTurnForPieceAtLocation: (Int,Int) -> ChessGameState -> Bool
isPlayersTurnForPieceAtLocation testLoc {board, totalMovesSoFar} =
  let
    maybeSquare = getBoardSquareAtLocation testLoc board
    currentTeamsMove = if totalMovesSoFar % 2 == 0 then Black else White
  in
    case maybeSquare of
      Just (FilledWith team _) -> team == currentTeamsMove
      _ -> False

{--
  Returns chessboard after attempting to move given piece.
--}
tryMovePiece: ChessGameState -> (Int,Int) -> (Int,Int) -> ChessGameState
tryMovePiece previousGameState startLoc endLoc =
  let
    validMovesForStartPiece = getPossibleMoveLocationsForGameState startLoc previousGameState
    moveAllowed = List.member endLoc validMovesForStartPiece
  in
    case moveAllowed of
      False -> previousGameState
      True -> {
          previousGameState | board = getBoardWithPieceMoved previousGameState.board startLoc endLoc
          , totalMovesSoFar = previousGameState.totalMovesSoFar + 1
        }

{--
  Returns the set of possible moves for the given square for the given game state.
--}
getPossibleMoveLocationsForGameState: (Int,Int) -> ChessGameState -> List (Int, Int)
getPossibleMoveLocationsForGameState testLoc state =
  let
    isPlayersTurn = isPlayersTurnForPieceAtLocation testLoc state
    moveLocs = getPossibleMoveLocations testLoc state.board
  in
    if isPlayersTurn then moveLocs else []

{--
  Get every possible move location for a given board square
  at the given location in the given chessboard. 
--}
getPossibleMoveLocations: (Int,Int) -> Chessboard -> List (Int, Int)
getPossibleMoveLocations testLoc board =
  let
    maybeSquare = getBoardSquareAtLocation testLoc board
    moveLocs = getPossibleMoveLocationsNotValidatingForCheck board testLoc
  in
    case maybeSquare of
      Just (FilledWith team _) ->
        moveLocs
          |> List.filter (\loc -> not (wouldMovePutPlayerKingInCheck team board testLoc loc))
      _ -> moveLocs

getPossibleMoveLocationsNotValidatingForCheck: Chessboard -> (Int,Int) -> List (Int, Int)
getPossibleMoveLocationsNotValidatingForCheck board testLoc =
  let
    maybeSquare = getBoardSquareAtLocation testLoc board
  in
    case maybeSquare of
      Nothing -> []
      Just square -> case square of
        Empty -> []
        FilledWith team piece ->
          let
            moveLocs = case piece of
              Pawn -> getIdealPawnMoveLocations team testLoc
              Rook -> getIdealRookMoveLocations testLoc
              Knight -> getIdealKnightMoveLocations testLoc
              Bishop -> getIdealBishopMoveLocations testLoc
              Queen -> getIdealQueenMoveLocations testLoc
              King -> getIdealKingMoveLocations testLoc
          in
            moveLocs
              |> List.filter (isValidMoveLocForPieceOfTeam team board)
              |> List.map (\moveLoc -> moveLoc.loc)

type CanMoveIf = 
  LocationEmptyOrContainsOpponentAndGivenLocationsAreEmpty (List (Int, Int))
  | LocationEmptyAndGivenLocationsAreEmpty (List (Int, Int))
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

wouldMovePutPlayerKingInCheck: Team -> Chessboard -> (Int, Int) -> (Int,Int) -> Bool
wouldMovePutPlayerKingInCheck movingPiecesTeam board startLoc endLoc =
  let
    boardWithPieceMoved = getBoardWithPieceMoved board startLoc endLoc
  in
    isPlayerKingInCheck movingPiecesTeam boardWithPieceMoved

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
    [{conditions = (LocationEmptyAndGivenLocationsAreEmpty []), loc = (curX,curY+moveDir)}
      , {conditions = LocationContainsOpponent, loc = (curX+1,curY+moveDir)}
      , {conditions = LocationContainsOpponent, loc = (curX-1,curY+moveDir)}
    ]
      |> List.append additionalMoveLoc

getIdealKnightMoveLocations: (Int,Int) -> List MoveLoc
getIdealKnightMoveLocations (startX, startY) =
  let
    emptyMovLoc = {
      conditions = (LocationEmptyOrContainsOpponentAndGivenLocationsAreEmpty [])
      , loc = (0,0)
    }
  in
    [ { emptyMovLoc | loc = (startX + 2, startY + 1) }
      , { emptyMovLoc | loc = (startX + 2, startY - 1) }
      , { emptyMovLoc | loc = (startX - 2, startY + 1) }
      , { emptyMovLoc | loc = (startX - 2, startY - 1) }
      , { emptyMovLoc | loc = (startX + 1, startY - 2) }
      , { emptyMovLoc | loc = (startX - 1, startY - 2) }
      , { emptyMovLoc | loc = (startX + 1, startY + 2) }
      , { emptyMovLoc | loc = (startX - 1, startY + 2) }
    ]

getIdealRookMoveLocations: (Int,Int) -> List MoveLoc
getIdealRookMoveLocations startLoc =
  getMoveLocsInDirection startLoc Left
  ++
  getMoveLocsInDirection startLoc Right
  ++
  getMoveLocsInDirection startLoc Up
  ++
  getMoveLocsInDirection startLoc Down

getIdealBishopMoveLocations: (Int,Int) -> List MoveLoc
getIdealBishopMoveLocations startLoc =
  getMoveLocsInDirection startLoc DiagonalUpAndRight
  ++
  getMoveLocsInDirection startLoc DiagonalUpAndLeft
  ++
  getMoveLocsInDirection startLoc DiagonalDownAndRight
  ++
  getMoveLocsInDirection startLoc DiagonalDownAndLeft

getIdealQueenMoveLocations: (Int,Int) -> List MoveLoc
getIdealQueenMoveLocations startLoc =
  getIdealBishopMoveLocations startLoc
  ++
  getIdealRookMoveLocations startLoc

getIdealKingMoveLocations: (Int,Int) -> List MoveLoc
getIdealKingMoveLocations (startX, startY) =
  let
    emptyMovLoc = {
      conditions = (LocationEmptyOrContainsOpponentAndGivenLocationsAreEmpty [])
      , loc = (0,0)
    }
  in
    [ { emptyMovLoc | loc = (startX, startY + 1) }
      , { emptyMovLoc | loc = (startX, startY - 1) }
      , { emptyMovLoc | loc = (startX + 1, startY + 1) }
      , { emptyMovLoc | loc = (startX + 1, startY - 1) }
      , { emptyMovLoc | loc = (startX - 1, startY + 1) }
      , { emptyMovLoc | loc = (startX - 1, startY - 1) }
      , { emptyMovLoc | loc = (startX + 1, startY) }
      , { emptyMovLoc | loc = (startX - 1, startY) }
    ]

type Direction =
  Up
  | Down
  | Left
  | Right
  | DiagonalUpAndRight
  | DiagonalUpAndLeft
  | DiagonalDownAndRight
  | DiagonalDownAndLeft

{--
  generates a list of the given length with elements ascending from one.
  example: generate 5 == [1,2,3,4,5]
--}
generateList: Int -> List Int
generateList length =
  if length <= 0
  then []
  else [1..length]

getMoveLocsInDirection: (Int,Int) -> Direction -> List MoveLoc
getMoveLocsInDirection startLoc direction =
  List.map (getMoveLocForDirection startLoc direction) (generateList 7)

getMoveLocForDirection: (Int,Int) -> Direction -> Int -> MoveLoc
getMoveLocForDirection startLoc direction distance = 
  let
    loc = getLocWithDeltaAddedInDirection startLoc direction distance
    inBetweenLocs =
      generateList (distance - 1)
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
    DiagonalUpAndRight -> (startX + distance, startY - distance)
    DiagonalUpAndLeft -> (startX - distance, startY - distance)
    DiagonalDownAndRight -> (startX + distance, startY + distance)
    DiagonalDownAndLeft -> (startX - distance, startY + distance)
