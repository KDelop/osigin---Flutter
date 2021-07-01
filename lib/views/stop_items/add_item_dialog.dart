import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_keyboard_popup_menu/keep_keyboard_popup_menu.dart';
import 'package:mca_driver_app/views/common/color_button.dart';

typedef AddItemHandler = Function(
  String description,
  int qty, {
  String masterItemId,
});

class AddItemDialog extends StatefulWidget {
  AddItemDialog(this.onAdd);

  final AddItemHandler onAdd;

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController _controller = TextEditingController();
  String _desc = '';
  String _qty = '';

  List<String> suggests = [
    'Ambient',
    'Cold',
    'Frozen',
    'Histology',
    'Equipment/Pump',
    'Narcotics',
    'Script',
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add Item'),
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller,
                onChanged: (v) => _desc = v,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Description",
                  suffixIcon: WithKeepKeyboardPopupMenu(
                    menuItemBuilder: (context, closePopup) => suggests
                        .map(
                          (value) => KeepKeyboardPopupMenuItem(
                            child: Text(value),
                            onTap: () {
                              closePopup();
                              _controller.text = value;
                              _desc = value;
                            },
                          ),
                        )
                        .toList(),
                    childBuilder: (context, openPopup) => IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      onPressed: openPopup,
                    ),
                  ),
                ),
              ),
              TextField(
                onChanged: (v) => _qty = v,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(labelText: "Quantity"),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ColorBtn(
                  title: 'ADD',
                  onPress: () {
                    widget.onAdd(_desc, int.parse(_qty));
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
