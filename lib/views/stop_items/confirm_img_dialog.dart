import 'package:flutter/material.dart';
import 'package:mca_driver_app/views/common/color_button.dart';

class ConfirmImagesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Would you like to take another photo?',
        textAlign: TextAlign.center,
      ),
      buttonPadding: EdgeInsets.only(right: 32, top: 0),
      titlePadding: EdgeInsets.only(top: 24, left: 20, right: 20),
      actions: <Widget>[
        ColorBtn(
          title: 'YES',
          onPress: () => Navigator.pop(context, true),
        ),
        ColorBtn(
          title: 'NO',
          onPress: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
