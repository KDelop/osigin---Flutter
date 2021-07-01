import 'package:flutter/material.dart';

class LetterCircleIcon extends StatelessWidget {
  final String _letter;

  LetterCircleIcon(this._letter);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      icon: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), shape: BoxShape.circle),
          width: 25,
          height: 25,
          child: Center(
              child: Text(
            _letter,
            textAlign: TextAlign.center,
          ))),
    );
  }
}