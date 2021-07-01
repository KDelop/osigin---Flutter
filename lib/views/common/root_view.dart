import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mca_driver_app/router.dart';
import 'package:mca_driver_app/stores/stop_list_view_store.dart';
import 'package:mca_driver_app/views/home/home_view.dart';

import '../../services/service_locator.dart';
import '../../stores/login_store.dart';
import '../login/login_view.dart';
import 'navigator.dart';

// TODO consider renaming app scaffolding
class RootView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var isAuthenticated =
        useStream(sl.get<LoginStore>().isAuthenticated).data ?? false;
    if (isAuthenticated) {
      sl.get<StopListViewStore>().getLatestItems();
    }

    // TODO: Consider pulling McaScaffold to a single root position here so that
    // Views don't have to inherit from it all the time.

    return Container(
      // child: isAuthenticated ? AppNavigator() : LoginView(),
      child: isAuthenticated ? HomeView() : LoginView(),
    );
  }
}
