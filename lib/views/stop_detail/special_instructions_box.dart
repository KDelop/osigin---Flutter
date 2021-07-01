import 'package:flutter/material.dart';

class SpecialInstructionsBox extends StatelessWidget {
  final String stop;
  final String client;
  final String location;
  final String order;

  SpecialInstructionsBox(
      {this.client = '', this.location = '', this.stop = '', this.order = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Special Instructions'.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                    [stop, location, order, client]
                        .where((element) => element != '')
                        .map((e) => "• $e")
                        .join('\n'),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
