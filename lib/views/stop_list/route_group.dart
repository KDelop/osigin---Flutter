import 'package:flutter/material.dart';
import 'stop_list_tile.dart';

class RouteGroup extends StatelessWidget {
  final List<StopListTile> stops;
  final String routeName;

  const RouteGroup({@required this.stops, @required this.routeName, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
            ListTile(
                title: Text(routeName,
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ] +
          stops,
    ));
  }
}