import 'package:catcher/catcher.dart';
import "package:image_picker/image_picker.dart";
import 'package:mca_driver_app/models/dropoff_item_vm.dart';
import 'package:mca_driver_app/models/recipient_model.dart';
import 'package:mca_driver_app/services/logger.dart';
import 'package:mca_driver_app/services/stop_service/memory_stop_service.dart';
import 'package:mca_driver_app/stores/stop_list_view_store.dart';
import '../services/service_locator.dart';
import '../util/mca_http_client.dart';
import 'package:overlay_support/overlay_support.dart';
import '../repo/image_upload_repository.dart';

import '../models/pickup_point_vm.dart';
import '../util/list_behavior_subject.dart';

import '../views/stop_items/items_view_mode.dart';

import '../models/delivery_item_vm.dart';
import '../services/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

class StopItemsViewStore {
  String stopId = '';
  String orderId = '';
  ItemsViewMode mode;

  List<DeliveryItemVm> get _extraItems => _itemsSubject.value;

  final BehaviorSubject<List<DeliveryItemVm>> _itemsSubject =
      BehaviorSubject<List<DeliveryItemVm>>.seeded([]);
  final BehaviorSubject<List<DropOffItemVm>> _dropOffItemsSubject =
      BehaviorSubject<List<DropOffItemVm>>.seeded([]);

  final BehaviorSubject<bool> isLoading = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isErrored = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isUploadingImage =
      BehaviorSubject<bool>.seeded(false);
  // final BehaviorSubject<String> proofImageUrl =
  //     BehaviorSubject<String>.seeded('');
  final BehaviorSubject<List<String>> lstProofImageUrl =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<List<String>> lstProofLabels =
      BehaviorSubject<List<String>>.seeded([]);
  Observable<bool> isPickupPointsConfirmed;
  final BehaviorSubject<bool> requireRecipient =
      BehaviorSubject<bool>.seeded(false);

  Observable<List<DeliveryItemVm>> get items {
    return _itemsSubject.stream;
  }

  Observable<List<DropOffItemVm>> get dropOffItems {
    return _dropOffItemsSubject.stream;
  }

  Observable<List<PickupPointVm>> get pickupPoints {
    return _pickupPointsSubject.stream;
  }

  final ListBehaviorSubject<PickupPointVm> _pickupPointsSubject =
      ListBehaviorSubject<PickupPointVm>();

  final StopService _stopSvc;
  final NavigationService _navSvc;

  StopItemsViewStore(this._stopSvc, this._navSvc) {
    isPickupPointsConfirmed = pickupPoints.map<bool>((list) {
      return list.where((vm) => vm.isConfirmed == false).length == 0;
    }).asBroadcastStream();
  }

  void initialize(String stopId, ItemsViewMode mode) async {
    _clear();

    this.stopId = stopId;
    this.mode = mode;
    isLoading.value = true;

    var stopDetail = await _stopSvc.getStopDetail(stopId);
    orderId = stopDetail.data.orderId;

    // check if recipient is necessary
    // if this value is true, then the driver must input
    // the recipient information before complete stop
    requireRecipient.value = stopDetail.data.requireRecipient;

    _itemsSubject.value = stopDetail.items;
    _dropOffItemsSubject.value = stopDetail.dropOffItems;

    _pickupPointsSubject.modify((list) {
      return stopDetail.pickupPoints;
    });

    // proofImageUrl.value = ''; // todo pull from viewmodel
    lstProofImageUrl.value = [];

    isLoading.value = false;
  }

  int get itemCount {
    return _extraItems.fold(0, (value, i) => value + i.qty);
  }

  void addItem(String description, int qty, {String masterItemId}) {
    _extraItems.add(
      DeliveryItemVm()
        ..description = description
        ..qty = qty
        ..originalQty = qty
        ..isAddedDuringLoadXfer = true
        ..masterItemId = masterItemId,
    );

    _itemsSubject.add(_extraItems);
  }

  void removeItem(String id) {
    _extraItems.removeWhere((i) => i.id == id);

    _itemsSubject.add(_extraItems);
  }

  void toggleConfirmation(String id, int qty) {
    var item = _extraItems.firstWhere((i) => i.id == id);

    item.isConfirmed = !item.isConfirmed;

    if (item.isConfirmed) {
      item.qty = qty;
    } else {
      item.qty = item.originalQty;
    }

    _itemsSubject.add(_extraItems);
  }

  void togglePickupPointConfirmation(String id) {
    _pickupPointsSubject.modify((list) {
      var pp = list.firstWhere((i) => i.id == id);
      pp.isConfirmed = !pp.isConfirmed;
      return list;
    });
  }

  Future<void> takePhoto(String label) async {
    // TODO, move this logic to stopService.takePhoto. Have url of photo
    // appear on the StopVm when it is confirmed.

    var picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) {
      return;
    }

    isUploadingImage.value = true;

    try {
      var url = await ImageUploadRepo(sl.get<McaHttpClient>())
          .uploadStopProof(image.path);

      // proofImageUrl.value = url;
      lstProofImageUrl.value.add(url);
      lstProofLabels.value.add(label);

      toast('uploaded photo');
    } on Exception catch (e, stackTrace) {
      toast('Experienced an error uploading image');
      Catcher.reportCheckedError(e, stackTrace);
    } finally {
      isUploadingImage.value = false;
    }
  }

  // void setPhoto(String path) async {
  //   proofImageUrl.value = 'path';
  // }

  // List<String> _getImageProofs() {
  //   if ((proofImageUrl.value ?? '') != '') {
  //     return [proofImageUrl.value];
  //   } else {
  //     return [];
  //   }
  // }

  void complete({RecipientModel recipient, String driverNotes}) async {
    var items = _itemsSubject.value.toList();
    if (mode == ItemsViewMode.pickup) {
      await _stopSvc.completePickup(
        stopId,
        orderId,
        items,
        lstProofImageUrl.value,
        lstProofLabels.value,
        recipient,
        driverNotes,
      );
    } else {
      await _stopSvc.completeDropoff(
        stopId,
        orderId,
        items,
        lstProofImageUrl.value,
        lstProofLabels.value,
        recipient,
        driverNotes,
      );
    }

    sl.get<StopListViewStore>().getLatestItems();

    _navSvc.pop();
  }

  void _clear() {
    // proofImageUrl.value = '';
    lstProofImageUrl.value = [];
    lstProofLabels.value = [];
    isLoading.value = true;
    _itemsSubject.value = [];
  }

  Future<void> handlePhotoButtonPressed(String label) async {
    await takePhoto(label);
  }
}
