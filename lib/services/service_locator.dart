import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import '../repo/order_repository.dart';
import 'order_service.dart';
import '../stores/order_detail_store.dart';
import '../stores/order_list_view_store.dart';
import 'stop_service/memory_stop_service.dart';
import '../repo/auth/auth_repo.dart';
import 'endpoint_service.dart';
import '../util/mca_http_client.dart';
import '../config.dart';
import '../repo/stop_repository.dart';
import 'stop_mapper.dart';

import '../stores/stop_detail_store.dart';
import '../stores/stop_list_view_store.dart';
import '../views/common/scaffold_builder.dart';
import 'notification/push_notification_connector.dart';
import '../repo/hive_repository.dart';
import '../stores/notification_center_store.dart';
import '../stores/stop_items_view_store.dart';
import 'notification/notification_mapper.dart';
import 'notification/notification_service.dart';
import 'overlay_service.dart';
import 'push_notification/push_notification_service.dart';
import 'push_notification/pushy_service.dart';
import 'package:ws_action/ws_action.dart';

import '../stores/login_store.dart';
import 'navigation_service.dart';

/// This will be used throughout the app to locate common services.
GetIt sl = GetIt.instance;

/// Need to run this function before app initialization
/// to configure dependencies.
Future setUpServiceLocator() async {
  sl.registerFactory<Client>(() => Client());

  sl.registerLazySingleton<WsConnectionService>(() {
    return WsConnectionService();
  });

  sl.registerLazySingleton<StopRepository>(
      () => StopRepository(sl.get<McaHttpClient>()));

  sl.registerLazySingleton<StopMapper>(() => StopMapper());

  // sl.registerLazySingleton<StopService>(
  //     () => McaStopService(sl.get<StopRepository>(), sl.get<StopMapper>()));

  sl.registerLazySingleton<StopService>(
      () => StopService(sl.get<StopRepository>(), sl.get<StopMapper>()));

  sl.registerSingleton<PushyService>(PushyService());

  sl.registerSingleton<PushNotificationService>(
      PushNotificationService(sl.get<PushyService>()));

  sl.registerSingleton<OverlayService>(OverlayService());

  sl.registerLazySingleton<HiveRepository>(() {
    var repo = HiveRepository();

    return repo;
  });

  sl.registerLazySingleton<NotificationMapper>(() => NotificationMapper());

  sl.registerSingleton<NavigationService>(NavigationService());

  sl.registerLazySingleton<NotificationService>(() => NotificationService(
      sl.get<NotificationMapper>(),
      sl.get<HiveRepository>(),
      sl.get<OverlayService>(),
      sl.get<NavigationService>(),
      sl.get<OrderService>()));

  sl.registerLazySingleton<NotificationCenterStore>(
      () => NotificationCenterStore(sl.get<NotificationService>()));

  sl.registerSingleton<ScaffoldBuilder>(ScaffoldBuilder());

  sl.registerLazySingleton<StopListViewStore>(() {
    var store =
        StopListViewStore(sl.get<StopService>(), sl.get<NavigationService>());

    return store;
  });

  sl.registerLazySingleton<StopDetailStore>(() {
    return StopDetailStore(sl.get<StopService>(), sl.get<NavigationService>());
  });

  sl.registerLazySingleton<PushNotificationConnector>(() {
    return PushNotificationConnector(
        sl.get<PushNotificationService>(), sl.get<NotificationService>());
  });

  sl.registerLazySingleton<McaHttpClient>(() {
    return McaHttpClient(sl.get<EndpointService>());
  });

  sl.registerLazySingleton<AuthRepo>(() {
    return AuthRepo(sl.get<McaHttpClient>());
  });

  sl.registerLazySingleton<EndpointService>(
      () => EndpointService()..baseUrl = endpoints[0]);

  sl.registerLazySingleton<LoginStore>(() {
    var store = LoginStore(sl.get<AuthRepo>(), sl.get<PushyService>(),
        sl.get<EndpointService>(), sl.get<PushNotificationConnector>());

    store.initialize();
    return store;
  });

  sl.registerLazySingleton<StopItemsViewStore>((() =>
      StopItemsViewStore(sl.get<StopService>(), sl.get<NavigationService>())));

  // Orders

  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepository(sl.get<McaHttpClient>()));

  sl.registerLazySingleton<OrderService>(() => OrderService());
  sl.registerLazySingleton<OrderListViewStore>(() => OrderListViewStore());
  sl.registerLazySingleton<OrderDetailStore>(
      () => OrderDetailStore(sl.get<OrderService>()));
}
