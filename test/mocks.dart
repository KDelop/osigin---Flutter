import 'package:mca_driver_app/services/clock_service.dart';
import 'package:mca_driver_app/services/push_notification/pushy_service.dart';
import 'package:mockito/mockito.dart';

class MockPushyService extends Mock implements PushyService {}

class MockClockService extends Fake implements ClockService {
  final DateTime _currentDt;

  MockClockService({DateTime datetime})
      : _currentDt = datetime ?? DateTime.now();

  @override
  DateTime getNow() {
    return _currentDt;
  }

  DateTime getDelta(Duration duration) {
    return DateTime(_currentDt.year, _currentDt.month, _currentDt.day,
            _currentDt.hour, _currentDt.minute, _currentDt.second)
        .add(duration);
  }

  DateTime getTime(int hour, int minute) {
    return DateTime(_currentDt.year, _currentDt.month, _currentDt.day, hour,
        minute, _currentDt.second);
  }
}
