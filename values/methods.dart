import 'package:flutter/material.dart';

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isItWhite;
  const DeadPiece({
    super.key,
    required this.imagePath,
    required this.isItWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      color: isItWhite ? Colors.grey.shade200 : Colors.grey.shade800,
      scale: 15,
    );
  }
}
