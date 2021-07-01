import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';

import '../../services/service_locator.dart';
import '../../stores/login_store.dart';
import '../../.env.dart';

class McaDrawer extends HookWidget {
  Widget build(BuildContext context) {
    var endpointService = sl.get<EndpointService>();

    var baseUrl = endpointService.baseUrl;
    var email = endpointService.loginSession.email;

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Osigin Driver',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(leading: Icon(Icons.person), title: Text(email)),
        // ListTile(
        //     leading: Icon(Icons.bug_report),
        //     title: Text("Logs"),
        //     onTap: () => sl.get<NavigationService>().showLogConsole()),
        // ListTile(
        //     leading: Icon(Icons.warning),
        //     title: Text("WARNING: Clear Storage"),
        //     onTap: () => Hive.deleteBoxFromDisk("notification_box")),
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () => sl.get<LoginStore>().logOut()),
        ListTile(
            leading: Icon(Icons.handyman),
            title: Text("${environment['APP_VERSION']}",
                style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)))),
        ListTile(
            leading: Icon(Icons.settings),
            title: Text("$baseUrl",
                style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1))))
      ],
    ));
  }
}
