class DateTimeFactory {
  DateTime currentDateTime;

  DateTimeFactory({this.currentDateTime}) {
    if (currentDateTime == null) {
      currentDateTime = DateTime.now();
    }
  }

  DateTime forward(Duration duration) {
    currentDateTime = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day,
            currentDateTime.hour,
            currentDateTime.minute,
            currentDateTime.second)
        .add(duration);
    return currentDateTime;
  }

  DateTime getTimeWithCurrentDate(int hour, int minute) {
    return DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, hour, minute, currentDateTime.second);
  }
}
