

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../common/mca_scaffold.dart';

class SettingsView extends HookWidget {

  @override
  Widget build(BuildContext context) {
    return McaScaffold(
      title: 'Settings',
      child: Text('Settings')
    );
  }

}