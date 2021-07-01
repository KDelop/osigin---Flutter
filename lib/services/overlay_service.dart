import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

/// Handles the in-app ui notification, set/clear
class OverlayService {
  final BehaviorSubject<bool> _isNotificationActive =
      BehaviorSubject<bool>.seeded(false);

  bool get isNotificationActive {
    return _isNotificationActive.value;
  }

  OverlaySupportEntry _latest;

  void clearOverlay() async {
    if (_latest != null) {
      _latest.dismiss();
      _latest = null;
      _isNotificationActive.value = false;
    }
  }

  Stream setNotification(String text, Function onView) {
    onView = onView ?? () {};
    clearOverlay();

    _isNotificationActive.value = true;

    _latest = showSimpleNotification(
      Text(text),
      trailing: Builder(builder: (context) {
        return FlatButton(
            textColor: Colors.white,
            onPressed: () {
              onView();
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('View'));
      }),
      background: Colors.green,
      autoDismiss: false,
      slideDismiss: true,
    );

    _latest.dismissed.then((val) {
      _isNotificationActive.value = false;
    });

    return _latest.dismissed.asStream();
  }
}
