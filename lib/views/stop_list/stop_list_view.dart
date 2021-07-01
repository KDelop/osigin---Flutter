import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/data_status.dart';
import '../common/loading_container.dart';
import '../../stores/stop_list_view_store.dart';
import 'stop_list_tile.dart';
import '../../services/service_locator.dart';
import '../common/mca_scaffold.dart';

class StopListView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var store = sl.get<StopListViewStore>();

    var model = useStream(store.model).data ?? [];

    var dataStatus = useStream(store.modelStatus).data ?? DataStatus.loading;

    var list = model
        .map((model) => StopListTile(
          
            model: model,
            onTap: () {
              store.handleItemTap(model.stopId);
            }))
        .toList();

    return McaScaffold(
      title: "Your Stops for Today",
      showBottomNav: true,
      child: LoadingContainer(
        isLoading: dataStatus == DataStatus.loading,
        child: RefreshIndicator(
          child: ListView(children: list),
          onRefresh: () async {
            await store.getLatestItems();
          },
        ),
      ),
    );
  }
}
