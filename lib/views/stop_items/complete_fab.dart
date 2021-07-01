import 'package:flutter/material.dart';

class CompleteFab extends StatelessWidget {
  final Function onPressed;

  const CompleteFab({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'complete_float_btn',
      onPressed: onPressed,
      child: Icon(Icons.done),
      backgroundColor: Colors.green,
    );
  }
}
