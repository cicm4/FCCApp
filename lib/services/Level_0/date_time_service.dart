class DateTimeFormatter {
  static String formatDate(int day, int month, int year) {
    final DateTime date = DateTime(year, month, day);
    return "${_getMonthName(date.month)} ${date.day}, ${date.year}";
  }

  static String formatTime(int hour) {
    final DateTime time = DateTime(0, 1, 1, hour);
    final String amPm = time.hour >= 12 ? "PM" : "AM";
    final int hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    return "$hour12:00 $amPm";
  }

  static String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "Unknown";
    }
  }
}