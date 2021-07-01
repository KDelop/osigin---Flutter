import 'package:flutter/material.dart';

import 'complete_fab.dart';

/// Fab = floating action button
class ItemsViewFab extends StatelessWidget {
  final Function onAdd;
  final Function onComplete;

  const ItemsViewFab({this.onAdd, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                heroTag: 'add_float_btn',
                onPressed: onAdd,
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              )),
          CompleteFab(onPressed: onComplete)
        ],
      ),
    );
  }
}
