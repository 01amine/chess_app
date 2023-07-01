enum PieceType { pawn, rook, bishop, knight, queen, king }

class Piece {
  final PieceType type;
  final bool isItWhite;
  final String imagePath;

  Piece({
    required this.type,
    required this.isItWhite,
    required this.imagePath,
  });
}
