import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mca_driver_app/models/dropoff_item_vm.dart';
import 'package:mca_driver_app/views/common/color_button.dart';
import 'package:overlay_support/overlay_support.dart';

import 'add_item_dialog.dart';

class AddItemDropOffDialog extends StatefulWidget {
  final List<DropOffItemVm> data;
  final AddItemHandler onAdd;

  AddItemDropOffDialog({
    @required this.data,
    @required this.onAdd,
  });

  @override
  _AddItemDropOffDialogState createState() => _AddItemDropOffDialogState();
}

class _AddItemDropOffDialogState extends State<AddItemDropOffDialog> {
  var _itemsData = [];
  String _qty = '';
  int _selIndex = 0;

  @override
  void initState() {
    _itemsData = widget.data;
    super.initState();
  }

  void onAddItems() {
    // validate the quantity.
    if (_qty.isEmpty) {
      toast('Please type the quantity.');
      return;
    }
    if (int.parse(_qty) > _itemsData[_selIndex].limit) {
      toast('Invalid quantity');
      return;
    }

    // add delivery items.
    widget.onAdd(
      _itemsData[_selIndex].description,
      int.parse(_qty),
      masterItemId: _itemsData[_selIndex].masterItemId,
    );
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Add Item',
        textAlign: TextAlign.center,
      ),
      titlePadding: EdgeInsets.only(top: 20.0, right: 20, left: 20),
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              DropdownButton<int>(
                isExpanded: true,
                value: _selIndex,
                items: _itemsData
                    .asMap()
                    .map(
                      (i, item) => MapEntry(
                        i,
                        DropdownMenuItem<int>(
                          value: i,
                          child: Text(item.description),
                        ),
                      ),
                    )
                    .values
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selIndex = value;
                  });
                },
                hint: Text('Select item.'),
              ),
              TextFormField(
                onChanged: (val) => _qty = val,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(labelText: "Quantity"),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ColorBtn(
                  title: 'ADD',
                  onPress: onAddItems,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
