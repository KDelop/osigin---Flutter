import 'dart:async';
import 'package:ws_action/ws_action.dart';

Future<WsConnectionService> wsConnectionServiceFactory(String username,
    String password, String websocketUrl, String authUrl) async {
  var completer = Completer<WsConnectionService>();

  var cookie = "not ganna use it"; //await establishLoginToken(username,
  //  password,
  //  authUrl);

  WsConnectionService.url = websocketUrl;
  WsConnectionService.tokenCookie = cookie;
  var wsConnService = WsConnectionService();

  var sub = wsConnService.statusObs().listen(null);

  sub.onData((val) {
    if (val.status == WsStatusType.CONNECTED) {
      completer.complete(wsConnService);
      sub.cancel();
    } else if (val.status != WsStatusType.CONNECTING) {
      completer.completeError(val);
      sub.cancel();
    }
  });

  wsConnService.connect();

  return completer.future;
}
