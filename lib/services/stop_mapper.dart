import 'package:mca_driver_app/models/dropoff_item_vm.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_detail_dto.dart';

import '../models/dto/mca_sails/item_dto.dart';
import '../models/pickup_point_vm.dart';
import '../models/delivery_item_vm.dart';
import '../models/stop_detail_vm.dart';

class StopMapper {
  StopDetailVm mapStopDetailDtoToStopDetailVm(StopDetailDto dto) {
    dto.scheduledTime = dto.scheduledTime.toLocal();

    return StopDetailVm()
      ..data = dto
      ..items = _mapToItemsVm([])
      ..dropOffItems = dto.pickedupStopItems
          .map((item) => DropOffItemVm()
            ..masterItemId = item.id
            ..description = item.name
            ..limit = item.pickedupCnt - item.dropoffCnt)
          .toList()
      ..pickupPoints = dto.pickupPoints
          .map((point) => PickupPointVm()
            ..id = point
            ..isConfirmed = false
            ..description = point)
          .toList();
  }

  List<DeliveryItemVm> _mapToItemsVm(Iterable<ItemDto> items) {
    return items
        .map((item) => DeliveryItemVm()
          ..id = item.name
          ..description = item.name
          ..isAddedDuringLoadXfer = false
          ..originalQty = item.qty
          ..isConfirmed = false
          ..qty = item.qty)
        .toList();
  }
}
