import 'package:hive/hive.dart';

import 'dto/mca_sails/order_detail_dto.dart';
import 'dto/mca_sails/order_status.dart';

part 'notification.g.dart';

@HiveType(typeId: 0)
class AppNotification {
  /// Intended as an id for the notification itself
  @HiveField(0)
  String id = '';

  @HiveField(1)
  String message = '';

  @HiveField(2)
  DateTime date = DateTime.now();
}

@HiveType(typeId: 4)
class OrderAssignedNotification extends AppNotification {
  @HiveField(3)
  String orderId;

  @HiveField(4)
  String orderNumber = '';

  @HiveField(5)
  String orderName = '';

  @HiveField(6)
  DateTime scheduledDate;

  @HiveField(7)
  OrderStatus orderStatus;

  OrderDetailDto toOrderDetailDto() {
    return OrderDetailDto()
      ..id = orderId
      ..orderNumber = orderNumber
      ..name = orderName
      ..scheduledDate = scheduledDate
      ..status = orderStatus;
  }
}

@HiveType(typeId: 5)
class OrderCanceledNotification extends AppNotification {
  @HiveField(3)
  String orderId;
}
