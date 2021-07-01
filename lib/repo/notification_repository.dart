
import 'package:rxdart/rxdart.dart';
import '../models/notification.dart';
import 'hive_repository.dart';

/// This stores notifications on local storage. Provides a stream of the current
/// list of notifications which should update on add/remove.
class NotificationRepository {

  final HiveRepository _repo;

  final BehaviorSubject<List<AppNotification>> _notificationListBs =
      BehaviorSubject<List<AppNotification>>.seeded([]);

  Observable<List<AppNotification>> _broadcastStream;

  Observable<List<AppNotification>> get collectionObs {

    if (_broadcastStream == null) {
      _broadcastStream = _notificationListBs.stream;
      _publishList();
    }

    return _broadcastStream;
  }

  NotificationRepository(this._repo);

  Future<void> addNotification(AppNotification notification) async {
    var box = await _repo.getNotificationBox();

    await box.put(notification.id, notification);

    _publishList();
  }

  Future<void> removeNotification(String uuid) async {
    var box = await _repo.getNotificationBox();
    await box.delete(uuid);
    _publishList();
  }

  _publishList() async {
    var box = await _repo.getNotificationBox();
    _notificationListBs.add(box.values.toList());
  }
}
