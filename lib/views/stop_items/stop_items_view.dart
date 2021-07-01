import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mca_driver_app/models/dropoff_item_vm.dart';
import 'package:mca_driver_app/models/recipient_model.dart';
import 'package:mca_driver_app/services/logger.dart';
import 'package:mca_driver_app/stores/stop_list_view_store.dart';
import 'package:mca_driver_app/views/common/badge_icon.dart';
import 'package:mca_driver_app/views/stop_items/driver_notes_dialog.dart';
import 'package:mca_driver_app/views/stop_items/add_item_dropoff_dialog.dart';
import 'package:mca_driver_app/views/stop_items/label_img_dialog.dart';
import 'package:mca_driver_app/views/stop_items/recipient_dialog.dart';
import 'package:overlay_support/overlay_support.dart';
import 'add_photo_fab.dart';
import '../../models/delivery_item_vm.dart';
import '../common/scaffold_builder.dart';
import 'add_item_dialog.dart';
import 'confirm_img_dialog.dart';
import 'confirm_qty_dialog.dart';
import '../../models/pickup_point_vm.dart';
import 'items_view_mode.dart';
import '../common/loading_container.dart';
import '../../services/service_locator.dart';
import '../../stores/stop_items_view_store.dart';
import 'confirm_dialog.dart';
import 'delivery_item_tile.dart';
import 'items_view_fab.dart';
import 'pickup_points.dart';
import 'pickup_points_wall_dialog.dart';

class StopItemsView extends HookWidget {
  final ItemsViewMode mode;

  const StopItemsView({this.mode});

  String _getTitle() {
    switch (mode) {
      case ItemsViewMode.pickup:
        return 'Confirm Pick-Up Items';
      case ItemsViewMode.dropoff:
        return 'Confirm Drop-Off Items';
    }
    return 'Items';
  }

  @override
  Widget build(BuildContext context) {
    var store = sl.get<StopItemsViewStore>();
    var scaffoldBuilder = sl.get<ScaffoldBuilder>();

    var items = useStream(store.items).data ?? [];
    var dropOffItems = useStream(store.dropOffItems).data ?? [];
    var isLoading = useStream(store.isLoading).data ?? true;
    var pickupPoints = useStream(store.pickupPoints).data ?? [];
    var requireRecipient = useStream(store.requireRecipient).data ?? false;

    var isImgProcess = useState<bool>(false);
    var recipient = useState<RecipientModel>();
    var driverNotes = useState<String>('');

    return scaffoldBuilder.build(
      showDrawer: false,
      title: _getTitle(),
      // floatingActionButton:
      //     _getFloatingActionButton(context, store, isImgProcess),
      floatingActionButton: _getSpeedDial(
        context,
        store,
        isImgProcess,
        requireRecipient,
        recipient,
        driverNotes,
        dropOffItems,
      ),
      child: LoadingContainer(
        isLoading: isLoading,
        child: ListView(
          children: _renderItems(context, items, pickupPoints) +
              // Add some space at the bottom
              [
                Container(
                  height: 200,
                )
              ],
        ),
      ),
    );
  }

  _renderItems(
    BuildContext context,
    List<DeliveryItemVm> items,
    List<PickupPointVm> pickupPoints,
  ) {
    var store = sl.get<StopItemsViewStore>();

    return _renderPickupPoints(pickupPoints) +
        (items.length == 0
            ? [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'No items',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                )
              ]
            : items
                .map<Widget>(
                  (item) => DeliveryItemTile(
                    item,
                    isForDropoff: mode == ItemsViewMode.dropoff,
                    onCheckboxChange: (nextVal) async {
                      if (nextVal == false) {
                        store.toggleConfirmation(item.id, item.qty);
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (_) => ConfirmQtyDialog(
                          itemName: item.description,
                          maxQty: item.qty,
                          onConfirm: (qty) {
                            store.toggleConfirmation(item.id, qty);
                          },
                        ),
                      );
                    },
                    onDelete: () async {
                      // Cancel delete if this
                      //is a delivery item
                      if (item.isAddedDuringLoadXfer == false) {
                        return false;
                      }

                      // Otherwise remove it!
                      store.removeItem(item.id);
                      return true;
                    },
                  ),
                )
                .toList());
  }

  Widget _getSpeedDial(
    BuildContext context,
    StopItemsViewStore store,
    ValueNotifier<bool> isImgProcess,
    bool requireRecipient,
    ValueNotifier<RecipientModel> recipient,
    ValueNotifier<String> driverNotes,
    List<DropOffItemVm> dropOffItems,
  ) {
    var isPickupPointsConfirmed =
        useStream(store.isPickupPointsConfirmed).data ?? false;

    var lstProofImageUrl = useStream(store.lstProofImageUrl).data ?? [];

    Future<void> handleImages(String label) async {
      isImgProcess.value = true;
      await store.handlePhotoButtonPressed(label);
      isImgProcess.value = false;
    }

    void showLabelImageDialog() {
      showDialog(
        context: context,
        builder: (_) => LabelImgDialog(
          onContinue: (label) {
            var imgLabel = label ?? '';
            handleImages(imgLabel);
          },
        ),
      );
    }

    void checkMultipleImages() async {
      if (lstProofImageUrl.length > 0) {
        var result = await showDialog(
          context: context,
          builder: (_) => ConfirmImagesDialog(),
        );
        if (result) {
          showLabelImageDialog();
        }
      } else {
        showLabelImageDialog();
      }
    }

    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      icon: Icons.menu,
      activeIcon: Icons.remove,
      buttonSize: 56.0,
      visible: true,
      closeManually: false,
      renderOverlay: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.check),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Complete Stop',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            if (mode == ItemsViewMode.pickup && !isPickupPointsConfirmed) {
              return showDialog(
                context: context,
                builder: (_) {
                  return PickupPointsWallDialog();
                },
              );
            } else {
              if (requireRecipient) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => RecipientDialog(
                    onContinue: (updatedValue) {
                      recipient.value = updatedValue;
                    },
                    currentData: recipient.value,
                  ),
                );
              }
              store.complete(
                driverNotes: driverNotes.value,
                recipient: recipient.value,
              );
            }

            // showDialog(
            //   context: context,
            //   builder: (_) {
            //     if (mode == ItemsViewMode.pickup) {
            //       // Make sure PickupPoints are confirmed before continuing.
            //       return !isPickupPointsConfirmed
            //           ? PickupPointsWallDialog()
            //           : ConfirmDialog(ItemsViewMode.pickup,
            //               onConfirm: store.complete);
            //     } else {
            //       return ConfirmDialog(ItemsViewMode.dropoff,
            //           onConfirm: store.complete);
            //     }
            //   },
            // );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.note),
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.white,
          label: 'Add a note',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => DriverNotesDialog(
                onContinue: (updatedValue) {
                  driverNotes.value = updatedValue;
                },
                driverNotes: driverNotes.value,
              ),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.mail),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          label: 'Add Item',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            print('SECOND CHILD');
            showDialog(
              context: context,
              builder: (_) {
                if (mode == ItemsViewMode.pickup) {
                  return AddItemDialog(store.addItem);
                } else {
                  return AddItemDropOffDialog(
                    data: dropOffItems,
                    onAdd: store.addItem,
                  );
                }
              },
            );
          },
        ),
        SpeedDialChild(
          child: Center(
            child: isImgProcess.value
                ? SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : BadgeIcon(
                    icon: Icon(Icons.photo),
                    badgeCount: lstProofImageUrl.length,
                  ),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Add Photo',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            if (!isImgProcess.value) {
              checkMultipleImages();
            } else {
              toast('Photo is uploading....');
            }
          },
        ),
      ],
    );
  }

  // Widget _getFloatingActionButton(BuildContext context,
  //     StopItemsViewStore store, ValueNotifier isImgProcess) {
  //   var isPickupPointsConfirmed =
  //       useStream(store.isPickupPointsConfirmed).data ?? false;
  //
  //   var lstProofImageUrl = useStream(store.lstProofImageUrl).data ?? [];
  //
  //   Future<void> handleImages(String label) async {
  //     isImgProcess.value = true;
  //     await store.handlePhotoButtonPressed(label);
  //     isImgProcess.value = false;
  //   }
  //
  //   void showLabelImageDialog() {
  //     showDialog(
  //       context: context,
  //       builder: (_) => LabelImgDialog(
  //         onContinue: (label) {
  //           var imgLabel = label ?? '';
  //           handleImages(imgLabel);
  //         },
  //       ),
  //     );
  //   }
  //
  //   void checkMultipleImages() async {
  //     if (lstProofImageUrl.length > 0) {
  //       var result = await showDialog(
  //         context: context,
  //         builder: (_) => ConfirmImagesDialog(),
  //       );
  //       if (result) {
  //         showLabelImageDialog();
  //       }
  //     } else {
  //       showLabelImageDialog();
  //     }
  //   }
  //
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.only(bottom: 10),
  //           child: AddPhotoFab(
  //             countImages: lstProofImageUrl.length,
  //             isProcess: isImgProcess.value,
  //             onPressed: () async {
  //               checkMultipleImages();
  //             },
  //           ),
  //         ),
  //         ItemsViewFab(
  //           onAdd: () async {
  //             showDialog(
  //               context: context,
  //               builder: (_) => AddItemDialog(store.addItem),
  //             );
  //           },
  //           onComplete: () {
  //             showDialog(
  //               context: context,
  //               builder: (_) {
  //                 if (mode == ItemsViewMode.pickup) {
  //                   // Make sure PickupPoints are confirmed before continuing.
  //                   return !isPickupPointsConfirmed
  //                       ? PickupPointsWallDialog()
  //                       : ConfirmDialog(ItemsViewMode.pickup,
  //                           onConfirm: store.complete);
  //                 } else {
  //                   return ConfirmDialog(ItemsViewMode.dropoff,
  //                       onConfirm: store.complete);
  //                 }
  //               },
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  List<Widget> _renderPickupPoints(List<PickupPointVm> pickupPoints) {
    var store = sl.get<StopItemsViewStore>();

    if (mode != ItemsViewMode.pickup || pickupPoints.length == 0) {
      return [];
    }

    return <Widget>[
      PickupPoints(
        pickupPoints: pickupPoints,
        onChange: (id, val) => store.togglePickupPointConfirmation(id),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Confirm Items', style: TextStyle(fontSize: 20)),
      )
    ];
  }
}
