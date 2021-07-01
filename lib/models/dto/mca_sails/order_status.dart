import 'package:hive/hive.dart';
part 'order_status.g.dart';

@HiveType(typeId: 6)
enum OrderStatus {
  @HiveField(0)
  created,

  @HiveField(1)
  assigned,

  @HiveField(2)
  rejected,

  @HiveField(3)
  accepted,

  @HiveField(4)
  inprogress,

  @HiveField(5)
  complete,

  @HiveField(6)
  canceled,

  @HiveField(7)
  invoiced,
}
