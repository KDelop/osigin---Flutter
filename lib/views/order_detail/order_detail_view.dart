import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';
import '../../stores/order_detail_store.dart';
import 'order_detail_view_body.dart';
import '../../models/data_status.dart';
import '../../services/service_locator.dart';
import '../common/data_status_container.dart';
import '../common/scaffold_builder.dart';

class OrderDetailView extends HookWidget {
  const OrderDetailView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = sl.get<OrderDetailStore>();

    var model = useStream(store.model).data ?? OrderDetailDto();
    var dataStatus = useStream(store.modelStatus).data ?? DataStatus.loading;

    return sl.get<ScaffoldBuilder>().build(
        showDrawer: false,
        title: _getAppBarLabel(model, dataStatus),
        child: DataStatusContainer(
            dataStatus: dataStatus,
            child: OrderDetailViewBody(
                model: model,
                onConfirm: store.acceptOrder,
                onReject: store.rejectOrder,
                onStopTap: store.handleStopTap)));
  }

  _getAppBarLabel(OrderDetailDto model, DataStatus status) {
    var isLoading = status == DataStatus.loading;
    return isLoading ? "Loading Order... " : "Order ${model.orderNumber}";
  }
}
