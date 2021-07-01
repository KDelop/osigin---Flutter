import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'stores/login_store.dart';
import 'services/navigation_service.dart';
import 'services/service_locator.dart';
import 'package:sentry/sentry.dart';
import '.env.dart';

const _dsn =
    "https://2dc6d961ef894b71a49018a0fd949eb2@o405811.ingest.sentry.io/5272096";

void runAppWithCatcher(Widget app) {
  var customParameters = {'authenticatedUser': ''};
  customParameters.addAll(environment);

  // STEP 1. Create catcher configuration.
  var debugOptions = CatcherOptions(SilentReportMode(),
      [ConsoleHandler(), ToastHandler(gravity: ToastHandlerGravity.center)],
      customParameters: customParameters);

  /// Release configuration.
  var releaseOptions = CatcherOptions(
      SilentReportMode(),
      [
        ToastHandler(gravity: ToastHandlerGravity.center),
        SentryHandler(SentryClient(dsn: _dsn)),
      ],
      customParameters: customParameters);

  /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  var catcher = Catcher(app,
      navigatorKey: sl.get<NavigationService>().navigatorKey,
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);

  // Pipe in custom params.
  sl.get<LoginStore>().authenticatedUser.listen((value) {
    catcher.getCurrentConfig().customParameters['authenticatedUser'] = value;
  });
}
