import 'package:fccapp/services/data/personalEvent.dart';

class Calendar {
  Map<String, dynamic> attendance;

  Calendar({required this.attendance});

  Map<String, dynamic>? get getAttendance => attendance;

  Future<void> setAttendance(Map<String, dynamic> newAttendance) async {
    attendance = newAttendance;
  }

  Future<void> setAttendanceFromList(List<PersonalEvent> data) async {
    attendance = {};
    for (PersonalEvent element in data) {
      String date = element.day + element.month + element.year;
      attendance[date] = {
        'start': element.startTime,
        'end': element.endTime,
        'status': element.status
      };
    }
  }

  Map<String, dynamic> getCalendarData() {
    return {
      'attendance': attendance,
    };
  }

  //from Map
  factory Calendar.fromMap(Map<String, dynamic> data) {
    //loop to print every element in attendance
    for (String key in data['attendance'].keys) {
      print(key);
      print(data['attendance'][key]);
    }
    return Calendar(
      attendance: data['attendance'],
    );
  }
}
