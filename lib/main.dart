import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:mca_driver_app/router.dart';
import 'package:mca_driver_app/services/navigation_service.dart';
import 'package:mca_driver_app/services/notification/notification_service.dart';
import 'package:mca_driver_app/stores/login_store.dart';
import 'package:mca_driver_app/util/debouncer.dart';
import 'catcher_config.dart';
import 'repo/hive_repository.dart';
import 'package:overlay_support/overlay_support.dart';

import 'services/push_notification/pushy_service.dart';
import 'services/service_locator.dart';
import 'views/common/root_view.dart';

void main() async {
  LogConsole.init();
  await setUpServiceLocator();
  // TODO.. perhaps some of the longer waiting initialization stuff needs
  // to happen once the initial runApp started.
  await sl.get<PushyService>().initialize();
  await sl.get<HiveRepository>().initialize();
  runAppWithCatcher(McaApp());
}

class McaApp extends StatefulWidget {
  McaApp({Key key}) : super(key: key);

  @override
  _McaAppState createState() => _McaAppState();
}

// ignore: prefer_mixin
class _McaAppState extends State<McaApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    var navigatorKey = sl.get<NavigationService>().navigatorKey;

    WidgetsBinding.instance.addObserver(this);
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Osigin Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.initRoute,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _lifecycleRefreshDebouncer.run(_onResume);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final Debouncer _lifecycleRefreshDebouncer = Debouncer(milliseconds: 100);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _lifecycleRefreshDebouncer.run(_onResume);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  /// What should we do when the app is resumed?
  void _onResume() {
    if (!sl.get<LoginStore>().isAuthenticated.value) {
      return;
    }
    sl.get<NotificationService>().refreshFromServer();
  }
}
