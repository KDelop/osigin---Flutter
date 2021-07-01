import 'dart:async';
import 'dart:convert';

import 'package:mca_driver_app/models/dto/push_notification/order_assigned_notification_dto.dart';
import 'package:mca_driver_app/models/dto/push_notification/order_canceled_notification_dto.dart';

import '../../models/dto/push_notification/notification_dto.dart';

import 'package:rxdart/rxdart.dart';

import 'pushy_service.dart';
import 'package:faker/faker.dart';

class PushNotificationService {
  Observable<NotificationDto> notifications;

  final PushyService _pushySvc;

  Observable<Map<String, dynamic>> _pushyStream;

  final StreamController<Map<String, dynamic>> _manualController =
      StreamController<Map<String, dynamic>>();

  void manualAdd() {
    var val = {
      'type': 'DispatchRequestedDriverToAcceptDelivery',
      'payload':
          json.encode({'deliveryId': Faker().guid.guid(), 'message': 'yo!!'})
    };
    _manualController.add(val);
  }

  PushNotificationService(this._pushySvc) {
    _pushyStream = _pushySvc.notificationStream;
    _setUpNotificationStream();
  }

  _setUpNotificationStream() {
    var jsonNotifications =
        _pushyStream.mergeWith([_manualController.stream]).asBroadcastStream();

    notifications = jsonNotifications
        .map<NotificationDto>((notification) {
          switch (notification['type']) {
            case ('OrderCanceled'):
              return OrderCanceledNotificationDto.fromJson(notification);

            case ('OrderAssigned'):
              return OrderAssignedNotificationDto.fromJson(notification);

            default:
              return NotificationDto.fromJson(notification);
          }
        })
        .where((n) => n != null)
        .asBroadcastStream();
  }
}
