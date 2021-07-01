import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps_launcher/maps_launcher.dart';

class AddressListTile extends StatelessWidget {
  const AddressListTile({address = '', Key key})
      : _address = address,
        super(key: key);

  final String _address;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: IconButton(
            icon: Icon(Icons.directions),
            onPressed: () {
              MapsLauncher.launchQuery(_address);
            }),
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: _address));
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Address Copied to Clipboard"),
          ));
        },
        title: Text(_address));
  }
}