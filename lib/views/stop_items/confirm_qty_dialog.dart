import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ConfirmQtyFn = void Function(int qty);

class ConfirmQtyDialog extends StatefulWidget {
  final String itemName;
  final int maxQty;
  final ConfirmQtyFn onConfirm;

  const ConfirmQtyDialog(
      {@required this.itemName,
      @required this.maxQty,
      @required this.onConfirm});

  @override
  _ConfirmQtyDialogState createState() => _ConfirmQtyDialogState();
}

class _ConfirmQtyDialogState extends State<ConfirmQtyDialog> {
  String _qty = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Quantity of ${widget.itemName}'),
      content: TextFormField(
        style: TextStyle(fontSize: 30),
        initialValue: widget.maxQty.toString(),
        onChanged: (val) => _qty = val,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(labelText: "Quantity"),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        FlatButton(
          child: const Text('CONFIRM'),
          onPressed: () {
            if (_qty == "") {
              _qty = widget.maxQty.toString();
            }
            var qty = int.tryParse(_qty);

            if (qty == null) {
              return;
            }

            widget.onConfirm(qty);

            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }
}
