import 'package:flutter/material.dart';
import 'package:mca_driver_app/models/recipient_model.dart';

class RecipientDialog extends StatefulWidget {
  @override
  _RecipientDialogState createState() => _RecipientDialogState();

  final Function(RecipientModel) onContinue;
  final RecipientModel currentData;
  RecipientDialog({@required this.onContinue, @required this.currentData});
}

class _RecipientDialogState extends State<RecipientDialog> {
  String name = '';
  String relation = '';
  String notes = '';

  @override
  void initState() {
    super.initState();
    if (widget.currentData != null) {
      name = widget.currentData.name;
      relation = widget.currentData.relation;
      notes = widget.currentData.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Recipient Information'),
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (v) => name = v,
                autofocus: true,
                decoration: InputDecoration(labelText: "Recipient Name"),
                initialValue: name,
              ),
              TextFormField(
                onChanged: (v) => relation = v,
                decoration:
                    InputDecoration(labelText: "Relationship to patient"),
                initialValue: relation,
              ),
              TextFormField(
                onChanged: (v) => notes = v,
                decoration: InputDecoration(labelText: "Notes"),
                initialValue: notes,
                maxLines: null,
              ),
              RaisedButton(
                child: Text('Continue'),
                onPressed: () {
                  widget.onContinue(
                    RecipientModel(
                      name: name,
                      relation: relation,
                      notes: notes,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
