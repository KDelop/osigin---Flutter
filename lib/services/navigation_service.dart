import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:mca_driver_app/stores/notification_center_store.dart';
import '../stores/order_detail_store.dart';
import '../stores/order_list_view_store.dart';
import '../views/order_detail/order_detail_view.dart';
import '../views/order_list/order_list_view.dart';
import '../stores/stop_detail_store.dart';
import '../stores/stop_list_view_store.dart';
import '../views/stop_detail/stop_detail_view.dart';
import '../views/stop_list/stop_list_view.dart';
import '../models/bottom_nav_entry.dart';
import '../views/notification_center/notification_center_view.dart';
import 'package:rxdart/rxdart.dart';
import '../views/stop_items/items_view_mode.dart';
import '../stores/stop_items_view_store.dart';
import '../views/stop_items/stop_items_view.dart';
import 'service_locator.dart';

/// This should be the app's interface to handling top level navigation events.
/// UI should talk to NavigationStore and not this class directly.
class NavigationService {
  /// Key to manage global navigator element
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BehaviorSubject<BottomNavEntry> currentNav =
      BehaviorSubject<BottomNavEntry>.seeded(BottomNavEntry.todaysStops);

  Future<dynamic> replaceView(String routeName) {
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  bool canPop() {
    return navigatorKey.currentState.canPop();
  }

  void pop() {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.pop();
    }
  }

  void handleTabChange(BottomNavEntry nav) {
    switch (nav) {
      case BottomNavEntry.todaysStops:
        if (currentNav.value != BottomNavEntry.todaysStops) {
          showDashboard();
        }
        return;

      case BottomNavEntry.notifications:
        if (currentNav.value != BottomNavEntry.notifications) {
          showNotificationCenter();
        }
        return;
    }
  }

  MaterialPageRoute _buildRoute(WidgetBuilder builder) {
    return MaterialPageRoute(builder: builder, maintainState: false);
  }

  Future<dynamic> showOrderDetail(String uuid) {
    return navigatorKey.currentState.push(_buildRoute((_) {
      sl.get<OrderDetailStore>().loadDetail(uuid);
      return OrderDetailView();
    }));
  }

  Future<dynamic> showStopDetail(String uuid) {
    return navigatorKey.currentState.push(_buildRoute((_) {
      sl.get<StopDetailStore>().loadDetail(uuid);
      return StopDetailView();
    }));
  }

  // Future<dynamic> showDashboard() {
  //   return navigatorKey.currentState.pushReplacement(_buildRoute((_) {
  //     currentNav.value = BottomNavEntry.todaysStops;
  //     sl.get<StopListViewStore>().getLatestItems();
  //     return StopListView();
  //   }));
  // }

  void showDashboard() {
    currentNav.value = BottomNavEntry.todaysStops;
    sl.get<StopListViewStore>().getLatestItems();
  }

  Future<dynamic> showPendingOrdersView() {
    return navigatorKey.currentState.pushReplacement(_buildRoute((_) {
      sl.get<OrderListViewStore>().getLatestItems();
      currentNav.value = BottomNavEntry.notifications;
      return OrderListView();
    }));
  }

  // Future<dynamic> showNotificationCenter() {
  //   return navigatorKey.currentState.pushReplacement(_buildRoute((_) {
  //     sl.get<NotificationCenterStore>().handleRefresh();
  //     currentNav.value = BottomNavEntry.notifications;
  //     return NotificationCenterView();
  //   }));
  // }

  void showNotificationCenter() {
    sl.get<NotificationCenterStore>().handleRefresh();
    currentNav.value = BottomNavEntry.notifications;
  }

  Future<dynamic> showItems(String id, ItemsViewMode mode) {
    return navigatorKey.currentState.push(_buildRoute((_) {
      // TODO: mode got duplicated in both of these calls.
      sl.get<StopItemsViewStore>().initialize(id, mode);

      return StopItemsView(mode: mode);
    }));
  }

  Future<dynamic> showLogConsole() {
    return navigatorKey.currentState.push(_buildRoute((_) => LogConsole()));
  }
}
