#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:http/http.dart';
import 'package:mca_driver_app/any.dart';

String _pushyUrl =
    "https://api.pushy.me/push?api_key=${Platform.environment['PUSHY_API_KEY']}";

void main(dynamic args) async {
  var key = Platform.environment['PUSHY_API_KEY'];

  if (key == null || key == "") {
    print('Please set env PUSHY_API_KEY');
    exit(1);
  }

  var argParser = ArgParser();

  argParser.addOption("type",
      help: "Pick which type of push notification to send",
      allowed: ['order_assigned', 'order_canceled', 'other']);
  argParser.addOption("push-token", help: "Provide the pushy API Token");

  ArgResults argResult;
  try {
    argResult = argParser.parse(args);
  } on FormatException {
    print(argParser.usage);
    exit(1);
  }

  var pushToken = argResult['push-token'];
  var pushType = argResult['type'];

  if (pushToken == null) {
    print("Need Push Token");
    print(argParser.usage);
    exit(1);
  }

  if (pushType == null) {
    print("Need Push Type");
    print(argParser.usage);
    exit(1);
  }

  var payload = _getPushNotification(pushToken, pushType);

  var c = Client();

  try {
    print("Sending msg to $pushToken");

    var rsult = await c.post(_pushyUrl,
        headers: {'Content-Type': 'application/json'}, body: payload);

    print(rsult.statusCode);
    print(rsult.body);
  } finally {
    c.close();
  }
}

String _buildPushNotification(String pushToken, String type, String message,
    Map<String, dynamic> dataFields) {
  // ignore: omit_local_variable_types
  Map<String, dynamic> msgData = {
    // The Android SDK uses the 'message' param of this obj.
    "message": message,
    "type": type,
  };

  msgData.addAll(dataFields ?? {});

  return jsonEncode({
    "to": pushToken,

    "data": msgData,

    // This notification is seemingly for iOS side of things.
    "notification": {
      "body": message,
      "badge": 1,
      "sound": {"name": "default"}
    }
  });
}

String _getPushNotification(String pushToken, String type) {
  switch (type) {
    case ('order_assigned'):
      return _buildPushNotification(
          pushToken,
          "OrderAssigned",
          "You have been assigned a new order. Please respond.",
          {"orderId": '5f7b7e16-6c80-4430-92bf-8e133f07fae1'});

    case ('order_canceled'):
      return _buildPushNotification(pushToken, "OrderCanceled",
          "An order was canceled", {"orderId": guid()});

    default:
      return _buildPushNotification(
          pushToken, "type", "some other message", {});
  }
}
