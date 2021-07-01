import 'dart:convert';

import '../../repo/util.dart';
// TODO fix post derust
// AuthenticationService authenticationSvcFactory(String authUrl,
//                                                String verifictionUrl) {
//   var clientFactory = HttpClientFactory();
//   return AuthenticationService(clientFactory, authUrl, verifictionUrl);
// }

// Future<String> establishLoginToken(String user,
//                                    String pass,
//                                    String authUrl) async {

//   var authSvc = authenticationSvcFactory(authUrl, "");
//   var cookie = await authSvc.authenticate(user, pass);

//   return cookie.cookieHeader;
// }

Future<void> changeUserPassword(
    String guid, String pass, String adminPass, String changePwUrl) async {
  var result = await withClient((c) {
    var basicAuth = base64Encode(utf8.encode('admin:$adminPass'));

    return c.post(changePwUrl,
        headers: {
          "Authorization": 'Basic $basicAuth',
          "Content-Type": "application/json"
        },
        body: jsonEncode({"userId": guid, "password": pass}));
  });

  if (result.statusCode != 200) {
    throw "ERROR: Could not change password for $guid";
  }
}
