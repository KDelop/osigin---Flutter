  // Future<void> _neverSatisfied(context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Accept?'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('You will never be satisfied.'),
  //               Text('You\’re like me. I’m never satisfied.'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Go Back'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('Accept Delivery'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // floatingActionButton: showFab
  //           ? Padding(
  //               padding: EdgeInsets.only(left: 25, right: 25),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   (FloatingActionButton.extended(
  //                       onPressed: () {_neverSatisfied(context);},
  //                       label: Text("Reject"),
  //                       backgroundColor: Colors.red)),
  //                   (FloatingActionButton.extended(
  //                       onPressed: () {},
  //                       label: Text("Accept"),
  //                       backgroundColor: Colors.green)),
  //                 ],
  //               ))
  //           : null