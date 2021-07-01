import 'package:mca_driver_app/models/delivery_item_vm.dart';
import 'package:mca_driver_app/models/dropoff_item_vm.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_detail_dto.dart';

import 'pickup_point_vm.dart';

class StopDetailVm {
  StopDetailDto data = StopDetailDto();

  List<DeliveryItemVm> items = [];

  List<DropOffItemVm> dropOffItems = [];

  /// Places the driver should check to pick up items.
  List<PickupPointVm> pickupPoints = [];
}
