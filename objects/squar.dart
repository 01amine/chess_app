import 'package:chess_app/objects/pieces.dart';
import 'package:chess_app/values/colors.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isItWhite;
  final Piece? piece;
  final bool isSelected;
  final bool isValid;
  final Function()? onTap;

  const Square({
    super.key,
    required this.isItWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if (isSelected && piece != null) {
      squareColor = Colors.green;
    } else if (isValid) {
      squareColor = Colors.green.shade300;
    } else {
      squareColor = isItWhite ? backgroundcolor : forgroundcolor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValid ? 8 : 0),
        child: piece != null
            ? Image.asset(
                piece!.imagePath,
                scale: 11,
                color: piece!.isItWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
