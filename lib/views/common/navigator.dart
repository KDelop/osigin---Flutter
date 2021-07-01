import 'package:flutter/material.dart';
import '../../stores/stop_list_view_store.dart';
import '../stop_list/stop_list_view.dart';

import '../../services/navigation_service.dart';
import '../../services/service_locator.dart';

///
/// Use NavigationService to handle navigation actions.
///
class AppNavigator extends StatelessWidget {
  const AppNavigator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationSerivce = sl.get<NavigationService>();
    var navigatorKey = sl.get<NavigationService>().navigatorKey;

    return WillPopScope(
      onWillPop: () {
        navigationSerivce.pop();
        return Future.value(false);
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) {
              // TODO, this may be duplicated when calling this route in the
              // navigation service.
              sl.get<StopListViewStore>().getLatestItems();
              return StopListView();
            },
            maintainState: false,
            settings: settings,
          );
        },
      ),
    );
  }
}
