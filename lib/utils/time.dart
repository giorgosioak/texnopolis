
class Time {
  static List<DateTime> getNext7Days() {
    List<DateTime> daysList = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      daysList.add(nextDay);
    }

    return daysList;
  }
}