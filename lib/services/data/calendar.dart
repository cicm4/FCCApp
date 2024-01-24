class Calendar {
  List<String> scheduledDays;
  Map<String, String?> attendance;

  Calendar({required this.scheduledDays, required this.attendance});

  List<String>? get getScheduledDays => scheduledDays;

  Map<String, String?>? get getAttendance => attendance;

  Future<void> setAttendance(Map<String, String?> newAttendance) async {
    attendance = newAttendance;
  }

  Future<void> setScheduledDays(List<String> newScheduledDays) async {
    scheduledDays = newScheduledDays;
  }

  Future<void> setAttendanceFromMap(Map<String, dynamic> data) async {
    attendance = data['attendance'];
  }

  Future<void> setScheduledDaysFromMap(Map<String, dynamic> data) async {
    scheduledDays = data['scheduledDays'];
  }

  Map<String, dynamic> getCalendarData() {
    return {
      'scheduledDays': scheduledDays,
      'attendance': attendance,
    };
  }

  //from Map
  factory Calendar.fromMap(Map<String, dynamic> data) {
    return Calendar(
      scheduledDays: data['scheduledDays'],
      attendance: data['attendance'],
    );
  }
}
