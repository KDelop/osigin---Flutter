import 'package:flutter/material.dart';
import 'package:mca_driver_app/views/common/color_button.dart';

class LabelImgDialog extends StatefulWidget {
  @override
  _LabelImgDialogState createState() => _LabelImgDialogState();

  final Function(String) onContinue;
  LabelImgDialog({@required this.onContinue});
}

class _LabelImgDialogState extends State<LabelImgDialog> {
  String _label;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Please label the picture',
        textAlign: TextAlign.center,
      ),
      titlePadding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 16),
      buttonPadding: EdgeInsets.only(right: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      // content: TextFormField(
      //   style: TextStyle(fontSize: 16),
      //   onChanged: (val) => _label = val,
      //   keyboardType: TextInputType.text,
      //   decoration: InputDecoration(
      //     contentPadding: EdgeInsets.only(
      //       top: 16,
      //       bottom: 8,
      //       left: 0,
      //       right: 8,
      //     ),
      //     isDense: true,
      //   ),
      // ),
      content: Container(
        width: 180.0,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: _label,
              items: <String>[
                'Damage to Package',
                'Door Tag',
                'Proof of Delivery',
                'Proof of Error',
                'Other',
              ].map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _label = value;
                });
              },
              hint: Text(' Select an Option'),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ColorBtn(
          title: 'CONTINUE',
          onPress: () {
            widget.onContinue(_label);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
