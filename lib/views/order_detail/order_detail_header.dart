import 'package:flutter/material.dart';

class OrderDetailHeader extends StatelessWidget {
  final String orderNumber;

  OrderDetailHeader({this.orderNumber = '???', Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Container(
              width: 50,
              height: 50,
              child: Icon(Icons.description_outlined, size: 50)),
          Expanded(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child:
                    Text('Order $orderNumber', style: TextStyle(fontSize: 30)),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
