import 'package:flutter/material.dart';
import 'package:mca_driver_app/views/common/color_button.dart';

class DriverNotesDialog extends StatefulWidget {
  @override
  _DriverNotesDialogState createState() => _DriverNotesDialogState();

  final Function(String) onContinue;
  final String driverNotes;
  DriverNotesDialog({@required this.onContinue, @required this.driverNotes});
}

class _DriverNotesDialogState extends State<DriverNotesDialog> {
  String notes = '';

  @override
  void initState() {
    super.initState();
    notes = widget.driverNotes;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Please type notes',
        textAlign: TextAlign.center,
      ),
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  onChanged: (v) => notes = v,
                  autofocus: true,
                  initialValue: notes,
                  maxLines: null,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ColorBtn(
                  title: 'Continue'.toUpperCase(),
                  onPress: () {
                    widget.onContinue(notes);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
