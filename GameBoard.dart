// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'package:chess_app/objects/pieces.dart';
import 'package:chess_app/objects/squar.dart';
import 'package:chess_app/values/colors.dart';
import 'package:chess_app/values/methods.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //tableau a deux dimensions
  late List<List<Piece?>> board;
  bool isItWhiteTurn = true;
  Piece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;
  List<List<int>> validMoves = [];
  List<Piece?> whitePiecesTaken = [];
  List<Piece?> blackPiecesTaken = [];
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool check = false;
  @override
  void initState() {
    super.initState();
    _initializeboard();
  }

  //initialization de the board
  void _initializeboard() {
    List<List<Piece?>> newboard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //initialize the pawns
    for (int i = 0; i < 8; i++) {
      newboard[1][i] = Piece(
        type: PieceType.pawn,
        isItWhite: false,
        imagePath: 'lib/assets/pawn.png',
      );
      newboard[6][i] = Piece(
        type: PieceType.pawn,
        isItWhite: true,
        imagePath: 'lib/assets/pawn.png',
      );
    }
    //initialize the rooks
    newboard[0][0] = Piece(
        type: PieceType.rook,
        isItWhite: false,
        imagePath: 'lib/assets/rook.png');
    newboard[0][7] = Piece(
        type: PieceType.rook,
        isItWhite: false,
        imagePath: 'lib/assets/rook.png');
    newboard[7][0] = Piece(
        type: PieceType.rook,
        isItWhite: true,
        imagePath: 'lib/assets/rook.png');
    newboard[7][7] = Piece(
        type: PieceType.rook,
        isItWhite: true,
        imagePath: 'lib/assets/rook.png');
    //initialize the bishops
    newboard[0][2] = Piece(
        type: PieceType.bishop,
        isItWhite: false,
        imagePath: 'lib/assets/bishop.png');
    newboard[0][5] = Piece(
        type: PieceType.bishop,
        isItWhite: false,
        imagePath: 'lib/assets/bishop.png');
    newboard[7][2] = Piece(
        type: PieceType.bishop,
        isItWhite: true,
        imagePath: 'lib/assets/bishop.png');
    newboard[7][5] = Piece(
        type: PieceType.bishop,
        isItWhite: true,
        imagePath: 'lib/assets/bishop.png');
    //initialize the knights
    newboard[0][1] = Piece(
        type: PieceType.knight,
        isItWhite: false,
        imagePath: 'lib/assets/knight.png');
    newboard[0][6] = Piece(
        type: PieceType.knight,
        isItWhite: false,
        imagePath: 'lib/assets/knight.png');
    newboard[7][1] = Piece(
        type: PieceType.knight,
        isItWhite: true,
        imagePath: 'lib/assets/knight.png');
    newboard[7][6] = Piece(
        type: PieceType.knight,
        isItWhite: true,
        imagePath: 'lib/assets/knight.png');
    //initialize the queens
    newboard[0][3] = Piece(
      type: PieceType.queen,
      isItWhite: false,
      imagePath: 'lib/assets/queen.png',
    );
    newboard[7][3] = Piece(
      type: PieceType.queen,
      isItWhite: true,
      imagePath: 'lib/assets/queen.png',
    );
    //initialize the kings
    newboard[0][4] = Piece(
        type: PieceType.king,
        isItWhite: false,
        imagePath: 'lib/assets/king.png');
    newboard[7][4] = Piece(
        type: PieceType.king,
        isItWhite: true,
        imagePath: 'lib/assets/king.png');
    board = newboard;
  }

  void pieceselected(int row, int col) {
    setState(() {
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isItWhite == isItWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      } else if (board[row][col] != null &&
          selectedPiece!.isItWhite == board[row][col]!.isItWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        moveThePiece(row, col);
      } else {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  List<List<int>> calculatedRowValidMoves(int row, int col, Piece? piece) {
    List<List<int>> candidatMoves = [];
    if (piece == null) {
      return [];
    }
    int direction = piece.isItWhite ? -1 : 1;
    switch (piece.type) {
      case PieceType.pawn:
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidatMoves.add([row + direction, col]);
        }
        if (row == 1 && !piece.isItWhite || row == 6 && piece.isItWhite) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null) {
            candidatMoves.add([row + 2 * direction, col]);
          }
        }
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isItWhite) {
          candidatMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isItWhite) {
          candidatMoves.add([row + direction, col + 1]);
        }
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isItWhite != piece.isItWhite) {
          candidatMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isItWhite != piece.isItWhite) {
          candidatMoves.add([row + direction, col + 1]);
        }
        break;

      case PieceType.bishop:
        var directions = [
          [-1, 1],
          [-1, -1],
          [1, -1],
          [1, 1],
        ];
        for (var pos in directions) {
          int i = 1;
          while (true) {
            var newRow = row + i * pos[0];
            var newCol = col + i * pos[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isItWhite != piece.isItWhite) {
                candidatMoves.add([newRow, newCol]);
              }
              break;
            }
            candidatMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case PieceType.rook:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
        ];
        for (var position in directions) {
          int i = 1;
          while (true) {
            var newRow = row + i * position[0];
            var newCol = col + i * position[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isItWhite != piece.isItWhite) {
                candidatMoves.add([newRow, newCol]);
              }
              break;
            }
            candidatMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case PieceType.knight:
        var directions = [
          [-2, 1],
          [-2, -1],
          [-1, 2],
          [-1, -2],
          [2, -1],
          [2, 1],
          [1, 2],
          [1, -2],
        ];
        for (var position in directions) {
          var newRow = row + position[0];
          var newCol = col + position[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isItWhite != piece.isItWhite) {
              candidatMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidatMoves.add([newRow, newCol]);
        }
        break;

      case PieceType.queen:
        var directions = [
          [-1, 1],
          [-1, -1],
          [1, -1],
          [1, 1],
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
        ];
        for (var position in directions) {
          int i = 1;
          while (true) {
            var newRow = row + i * position[0];
            var newCol = col + i * position[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isItWhite != piece.isItWhite) {
                candidatMoves.add([newRow, newCol]);
              }
              break;
            }
            candidatMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case PieceType.king:
        var directions = [
          [-1, 1],
          [-1, -1],
          [1, -1],
          [1, 1],
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
        ];
        for (var position in directions) {
          var newRow = row + position[0];
          var newCol = col + position[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isItWhite != piece.isItWhite) {
              candidatMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidatMoves.add([newRow, newCol]);
        }
        break;
      default:
    }
    return candidatMoves;
  }

  List<List<int>> calculateRealValidMoves(
      int row, int col, Piece? piece, bool checksumiltion) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMove = calculatedRowValidMoves(row, col, piece);
    if (checksumiltion) {
      for (var move in candidateMove) {
        int endRow = move[0];
        int endCol = move[1];
        if (simulationMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMove;
    }
    return realValidMoves;
  }

  void moveThePiece(int newRow, int newCol) {
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isItWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;
    if (isKingInCheck(!isItWhiteTurn)) {
      check = true;
    } else {
      check = false;
    }

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
    setState(() {
      if (isCheckMate(!isItWhiteTurn)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Game End'),
            actions: [
              TextButton(
                onPressed: restartGame,
                child: const Text('New Game'),
              ),
            ],
          ),
        );
      }
    });
    isItWhiteTurn = !isItWhiteTurn;
  }

  bool isKingInCheck(bool isKingWhite) {
    List<int> kingPosition =
        isKingWhite ? whiteKingPosition : blackKingPosition;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isItWhite == isKingWhite) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool simulationMoveIsSafe(
      Piece piece, int startRow, int startCol, int endRow, int endCol) {
    Piece? originalDestinationPosition = board[endRow][endCol];
    List<int>? originalKingPosition;
    if (piece.type == PieceType.king) {
      originalKingPosition =
          piece.isItWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isItWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isItWhite);

    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPosition;

    if (piece.type == PieceType.king) {
      originalKingPosition =
          piece.isItWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isItWhite) {
        whiteKingPosition = originalKingPosition;
      } else {
        blackKingPosition = originalKingPosition;
      }
    }
    return !kingInCheck;
  }

  bool isCheckMate(bool isItWhiteKing) {
    if (!isKingInCheck(isItWhiteKing)) {
      return false;
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isItWhite != isItWhiteKing) {
          continue;
        }
        List<List<int>> validMoves =
            calculateRealValidMoves(i, j, board[i][j], true);
        if (validMoves.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void restartGame() {
    Navigator.pop(context);
    _initializeboard();
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isItWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: whitePiecesTaken.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiecesTaken[index]!.imagePath,
                isItWhite: true,
              ),
            ),
          ),
          Text(check ? 'CHECK!' : ''),
          Expanded(
            flex: 4,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8 * 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  int x = index ~/ 8;
                  int y = index % 8;
                  bool isselected = selectedRow == x && selectedCol == y;
                  bool isValidMoves = false;
                  for (var position in validMoves) {
                    if (position[0] == x && position[1] == y) {
                      isValidMoves = true;
                    }
                  }
                  if ((x + y) % 2 == 0) {
                    return Square(
                      isItWhite: true,
                      piece: board[x][y],
                      isSelected: isselected,
                      onTap: () => pieceselected(x, y),
                      isValid: isValidMoves,
                    );
                  } else {
                    return Square(
                      isItWhite: false,
                      piece: board[x][y],
                      isSelected: isselected,
                      onTap: () => pieceselected(x, y),
                      isValid: isValidMoves,
                    );
                  }
                }),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: blackPiecesTaken.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPiecesTaken[index]!.imagePath,
                isItWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
