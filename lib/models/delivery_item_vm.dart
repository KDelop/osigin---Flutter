import 'package:uuid/uuid.dart';

class DeliveryItemVm {
  DeliveryItemVm();

  String id = Uuid().v1();

  String masterItemId;

  String description = '';

  int qty = 1;
  int originalQty = 1;

  bool isConfirmed = false;

  // This only indicates that it was added by the driver during load transfer
  // pickup/dropoff
  bool isAddedDuringLoadXfer = false;

  String toString() {
    return "id:$id $description $qty";
  }
}
