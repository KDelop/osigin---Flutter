
///
/// Allows getting datetime in 45-minute increments from 8am
///
class DateTimeIntervalIterator {
  DateTime _start;

  DateTimeIntervalIterator(DateTime date) {
    var _now = date;

    _start = DateTime.utc(
      _now.year, _now.month, _now.day, 8+6, 0
    );

    _start = _start.toLocal();
  }

  DateTime next({int minutes = 45}) {
    _start = _start.add(Duration(minutes: minutes));
    return _start;
  }
}
