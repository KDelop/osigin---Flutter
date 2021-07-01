import 'package:flutter/material.dart';
import 'confirm_response_dialog.dart';

class OrderDetailConfirmTile extends StatelessWidget {
  const OrderDetailConfirmTile(
      {@required this.onConfirm, @required this.onReject, key})
      : super(key: key);

  final Function onConfirm;
  final Function onReject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Pending Your Confirmation',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: Colors.green,
                              textStyle: TextStyle(fontSize: 25)),
                          icon: Icon(Icons.check_box_rounded),
                          label: Text('Confirm'),
                          onPressed: () => {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ConfirmResponseDialog(
                                          title: 'Confirm your assignment?',
                                          actionText: 'Confirm',
                                          onConfirm: onConfirm);
                                    })
                              }),
                      Spacer(),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            primary: Colors.redAccent,
                            textStyle: TextStyle(fontSize: 25)),
                        icon: Icon(Icons.cancel),
                        label: Text('Reject'),
                        onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ConfirmResponseDialog(
                                    title: 'Reject your assignment?',
                                    actionText: 'Reject',
                                    onConfirm: onReject);
                              })
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
            // ListTile(
            //   leading: Icon(Icons.pending_actions_sharp),
            //   subtitle: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child:
            //   ),
            //   title: Text('Pending Your Confirmation'),
            // ),
            ),
      ),
    );
  }
}
