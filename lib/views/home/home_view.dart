import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mca_driver_app/models/bottom_nav_entry.dart';
import 'package:mca_driver_app/services/navigation_service.dart';
import 'package:mca_driver_app/services/service_locator.dart';
import 'package:mca_driver_app/views/common/bottom_navigation_bar.dart';
import 'package:mca_driver_app/views/notification_center/notification_center_view.dart';
import 'package:mca_driver_app/views/stop_list/stop_list_view.dart';

class HomeView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var navigationService = sl.get<NavigationService>();
    var selNav = useStream(navigationService.currentNav).data;

    return Scaffold(
      body: selNav == BottomNavEntry.todaysStops
          ? StopListView()
          : NotificationCenterView(),
      bottomNavigationBar: McaBottomNav(),
    );
  }
}
