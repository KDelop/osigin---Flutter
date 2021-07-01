import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mca_driver_app/models/data_status.dart';
import 'package:mca_driver_app/stores/order_list_view_store.dart';
import 'package:mca_driver_app/views/common/loading_container.dart';
import 'package:mca_driver_app/views/order_list/order_list_tile.dart';
import '../../services/service_locator.dart';
import '../common/mca_scaffold.dart';

class NotificationCenterView extends HookWidget {
  const NotificationCenterView({Key key}) : super(key: key);
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
        title: "Notifications",
        showBottomNav: true,
        child: LoadingContainer(
          isLoading: false,
          child: RefreshIndicator(
            child: ListView(children: list),
            onRefresh: () async {
              await store.getLatestItems();
            },
          ),
        ));
  }
}
