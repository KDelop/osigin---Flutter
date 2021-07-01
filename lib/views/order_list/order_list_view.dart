import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../stores/order_list_view_store.dart';
import '../../models/data_status.dart';
import '../common/loading_container.dart';
import '../../services/service_locator.dart';
import '../common/mca_scaffold.dart';
import 'order_list_tile.dart';

class OrderListView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var store = sl.get<OrderListViewStore>();

    var model = useStream(store.model).data ?? [];

    var dataStatus = useStream(store.modelStatus).data ?? DataStatus.loading;

    var list = model
        .map((model) => OrderListTile(
            model: model,
            onTap: () {
              store.handleItemTap(model.id);
            }))
        .toList();

    return McaScaffold(
        title: "Your Pending Assignments",
        showBottomNav: true,
        child: LoadingContainer(
          isLoading: dataStatus == DataStatus.loading,
          child: RefreshIndicator(
            child: ListView(children: list),
            onRefresh: () async {
              await store.getLatestItems();
            },
          ),
        ));
  }
}
