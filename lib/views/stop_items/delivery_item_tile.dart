import 'package:flutter/material.dart';

import '../../models/delivery_item_vm.dart';

typedef DeleteHandler = Future<bool> Function();

class DeliveryItemTile extends StatelessWidget {
  final DeliveryItemVm itemVm;
  final Function(bool) onCheckboxChange;
  final DeleteHandler onDelete;
  final bool isForDropoff;

  DeliveryItemTile(
    this.itemVm, {
    this.isForDropoff = false,
    this.onCheckboxChange,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var newQty = itemVm.qty != itemVm.originalQty;

    var card = Card(
      child: ListTile(
        leading: _getLeading(),
        title: Row(
          children: [
            Expanded(child: Text(itemVm.description)),
            Text(
              'Qty: ${itemVm.qty}',
              style: TextStyle(
                fontWeight: newQty ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );

    return Dismissible(
      key: Key(itemVm.id),
      confirmDismiss: (_) => onDelete(),
      child: card,
    );
  }

  Widget _getLeading() {
    if (itemVm.isAddedDuringLoadXfer) {
      return Padding(padding: EdgeInsets.all(30));
    }

    return Checkbox(
      value: itemVm.isConfirmed,
      onChanged: onCheckboxChange,
    );
  }
}
