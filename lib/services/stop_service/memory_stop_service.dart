import 'package:mca_driver_app/models/dto/mca_sails/dropoff_item_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/pickup_item_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_list_item_dto.dart';
import 'package:mca_driver_app/models/recipient_model.dart';

import '../../models/dto/mca_sails/item_dto.dart';
import '../../repo/stop_repository.dart';

import '../stop_mapper.dart';

import '../../models/delivery_item_vm.dart';

import '../../models/stop_detail_vm.dart';

class StopService {
  final StopRepository _stopRepo;
  final StopMapper _stopMapper;

  StopService(this._stopRepo, this._stopMapper);

  Future<List<StopListItemDto>> getTodaysStops() async {
    var stopsDto = await _stopRepo.listMyStops();
    return stopsDto;
  }

  Future<StopDetailVm> getStopDetail(String id) async {
    var stop = await _stopRepo.getById(id);
    var detailVm = _stopMapper.mapStopDetailDtoToStopDetailVm(stop);
    return detailVm;
  }

  Future<List<DeliveryItemVm>> getItems(String stopId) async {
    var stop = await getStopDetail(stopId);
    return stop.items;
  }

  void completePickup(
    String stopId,
    String orderId,
    List<DeliveryItemVm> items,
    List<String> photos,
    List<String> labels,
    RecipientModel recipient,
    String driverNotes,
  ) async {
    // TODO: deprecated items, consider to remove this in the future.
    var itemDtos = _mapToItemDtos(items);

    var photosData = <Map>[];
    for (var i = 0; i < photos.length; i++) {
      photosData.add({
        'url': photos[i],
        'label': labels[i],
      });
    }

    // complete pickup store
    await _stopRepo.completePickup(
      stopId,
      items: itemDtos,
      photos: photosData,
      recipient: recipient,
      driverNotes: driverNotes,
    );

    // save pickup items
    var pickupItemDtos = _mapToPickupItemDtos(items);

    await _stopRepo.savePickupItems(
      orderId,
      stopId,
      items: pickupItemDtos,
    );
  }

  List<ItemDto> _mapToItemDtos(List<DeliveryItemVm> items) {
    var itemDtos = items
        .map((item) => ItemDto()
          ..name = item.description
          ..qty = item.qty)
        .toList();
    return itemDtos;
  }

  List<PickupItemDto> _mapToPickupItemDtos(List<DeliveryItemVm> items) {
    var pickupItemDtos = items
        .map(
          (item) => PickupItemDto()
            ..name = item.description
            ..quantity = item.qty,
        )
        .toList();
    return pickupItemDtos;
  }

  List<DropoffItemDto> _mapToDropOffItemDtos(
    List<DeliveryItemVm> items,
  ) {
    var dropOffItemDtos = items
        .map(
          (item) => DropoffItemDto()
            ..masterItemId = item.masterItemId
            ..name = item.description
            ..quantity = item.qty,
        )
        .toList();
    return dropOffItemDtos;
  }

  void completeDropoff(
    String stopId,
    String orderId,
    List<DeliveryItemVm> items,
    List<String> photos,
    List<String> labels,
    RecipientModel recipient,
    String driverNotes,
  ) async {
    // TODO: deprecated items, consider to remove this in the future.
    var itemDtos = _mapToItemDtos(items);

    var photosData = <Map>[];
    for (var i = 0; i < photos.length; i++) {
      photosData.add({
        'url': photos[i],
        'label': labels[i],
      });
    }

    await _stopRepo.completeDropoff(
      stopId,
      items: itemDtos,
      photos: photosData,
      recipient: recipient,
      driverNotes: driverNotes,
    );

    // save drop items
    var dropOffItemDtos = _mapToDropOffItemDtos(items);

    await _stopRepo.saveDropoffItems(orderId, stopId, items: dropOffItemDtos);
  }
}
