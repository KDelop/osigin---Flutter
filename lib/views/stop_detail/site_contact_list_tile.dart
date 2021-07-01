import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class SiteContactListTile extends StatelessWidget {
  const SiteContactListTile({phone = '', name = '', Key key})
      : _phone = phone,
        _name = name,
        super(key: key);

  final String _phone;
  final String _name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: IconButton(
            icon: Icon(Icons.contact_phone),
            onPressed: () {
              launch("tel:$_phone");
            }),
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: _phone));
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Phone Number Copied to Clipboard"),
          ));
        },
        title: Text("$_phone - $_name"));
  }
}