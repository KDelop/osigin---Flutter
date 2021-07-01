import 'package:flutter/material.dart';
import 'package:mca_driver_app/stores/stop_list_view_store.dart';
import 'package:mca_driver_app/views/home/home_view.dart';
import 'package:mca_driver_app/views/login/login_view.dart';
import 'package:mca_driver_app/views/notification_center/notification_center_view.dart';
import 'package:mca_driver_app/views/stop_list/stop_list_view.dart';
import 'services/service_locator.dart';
import 'views/common/root_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(
          builder: (_) => RootView(),
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );
      case homeRoute:
        sl.get<StopListViewStore>().getLatestItems();
        return MaterialPageRoute(
          builder: (_) => HomeView(),
        );
      case stopListRoute:
        return MaterialPageRoute(
          builder: (_) => StopListView(),
        );
      case notificationRoute:
        return MaterialPageRoute(
          builder: (_) => NotificationCenterView(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => _ErrorView(
            name: settings.name,
          ),
        );
    }
  }

  static const String initRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String stopListRoute = '/stopList';
  static const String notificationRoute = '/notification';
}

class _ErrorView extends StatelessWidget {
  final String name;
  _ErrorView({@required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('No route defined for $name')),
    );
  }
}
