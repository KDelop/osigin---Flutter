import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../services/service_locator.dart';
import '../../stores/login_store.dart';

import 'login_form.dart';

class LoginView extends HookWidget {

  @override
  Widget build(BuildContext context) {

    final loginStore = sl.get<LoginStore>();

    var isInitialized = useStream(loginStore.isInitialized).data ?? false;

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(50.0),
          child: isInitialized ? LoginForm() : CircularProgressIndicator()
        )
      )
    );
  }
}