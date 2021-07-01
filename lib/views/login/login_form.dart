import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mca_driver_app/services/endpoint_service.dart';
import '../../services/service_locator.dart';
import '../../stores/login_store.dart';
import 'endpoint_selector.dart';
import 'package:dotenv/dotenv.dart' as environment;

class LoginForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final loginStore = sl.get<LoginStore>();

    ValueNotifier<String> email;
    ValueNotifier<String> password;

    var showDebug = useState(false);

    if (kReleaseMode) {
      sl.get<EndpointService>().baseUrl = 'https://prodserver.sqrlrx.io';
      email = useState('');
      password = useState('');
    } else {
      // email = useState('test_driver@example.com');
      // password = useState('grand_canyon2');
      email = useState('doc@parsesoftware.com');
      password = useState('parse2020');
    }

    final isLoading = useStream(loginStore.isLoading).data ?? true;
    final errors = useStream(loginStore.errors).data ?? [];
    final deviceToken = useStream(loginStore.pushToken).data ?? '';

    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: GestureDetector(
                onLongPress: () => showDebug.value = true,
                child: Text("Osigin",
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)))),
        TextFormField(
          initialValue: email.value,
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            labelText: 'email',
          ),
          onChanged: (value) {
            email.value = value.toLowerCase();
          },
        ),
        TextFormField(
            initialValue: password.value,
            obscureText: true,
            onChanged: (value) {
              password.value = value;
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'password',
            )),
        !isLoading
            ? RaisedButton(
                onPressed: () {
                  loginStore.authenticate(email.value, password.value);
                },
                child: Text("Login"))
            : CircularProgressIndicator(),
        errors.length == 0 || isLoading
            ? Text('')
            : Text(errors.last, style: TextStyle(color: Colors.red)),
        showDebug.value ? EndpointSelector() : Text(''),
        Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Version: ${environment.env['APP_VERSION']}'),
                Text('Device Token: $deviceToken',
                    style: TextStyle(color: Colors.grey)),
              ],
            ))
      ],
    ));
  }
}
