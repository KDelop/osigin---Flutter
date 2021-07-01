import 'dart:async';

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../logger.dart';
import '../navigation_service.dart';
import '../service_locator.dart';

// Please place this code in main.dart,
// After the import statements, and outside any Widget class (top-level)
void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  var notificationTitle = 'Osigin Driver';
  String notificationText = data['message'] ?? 'No Message Specified';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  Pushy.notify(notificationTitle, notificationText, data);

  sl.get<PushyService>()._handlePushNotification(data);

  // Clear iOS app badge number
  Pushy.clearBadge();
}

/// Wrapper class around the static methods of Pushy
class PushyService {
  final StreamController<Map<String, dynamic>> _pushNotificationSubject =
      StreamController<Map<String, dynamic>>();

  Observable<Map<String, dynamic>> _pushNotificationStreamBroadcastStream;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await getDeviceToken();

    // Start the Pushy service
    Pushy.listen();

    Pushy.setNotificationListener(backgroundNotificationListener);
    Pushy.setNotificationClickListener(_handleNotificationClick);

    // Request the WRITE_EXTERNAL_STORAGE permission on Android so that the
    // Pushy SDK will be able to persist the token in the external storage
    Pushy.requestStoragePermission();
  }

  void _handlePushNotification(Map<String, dynamic> msg) {
    logger.e('Pushysvc recieved msg $msg');
    _pushNotificationSubject.add(msg);
  }

  void _handleNotificationClick(Map<String, dynamic> msg) {
    logger.e('Pushysvc recieved click msg $msg');
    sl.get<NavigationService>().showNotificationCenter();
  }

  /// Stream that emits raw push notifications (json)
  /// It will emit push notifications that haven't been consumed yet.
  Observable<Map<String, dynamic>> get notificationStream {
    if (_pushNotificationStreamBroadcastStream == null) {
      _pushNotificationStreamBroadcastStream =
          Observable(_pushNotificationSubject.stream.asBroadcastStream());
    }
    return _pushNotificationStreamBroadcastStream;
  }

  void clearIOSBadge() {
    Pushy.clearBadge();
  }

  Future<String> getDeviceToken() async {
    try {
      // Register the device for push notifications
      // TODO: fix the storage issue
      var deviceToken = await Pushy.register();

      // Print token to console/logcat
      print('Pushy Device token: $deviceToken');

      return deviceToken;
    } on PlatformException catch (error) {
      // Simulator device throws an error... it would be nice to catch this
      // and handle it gracefully but log the other errrors.
      // Print to console/logcat
      Catcher.reportCheckedError(error, null);
      return 'NOTAVAILABLE';
    }
  }
}
