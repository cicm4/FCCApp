import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:fccapp/services/data/calendar.dart';

class CalendarService {
  DBService dbs;
  DBUserService dbu;
  UserService us;
  Calendar calendar;
  String? uid;

  CalendarService(
      {required this.dbs, required this.us, required this.calendar, this.uid})
      : dbu = DBUserService(dbService: dbs, userService: us);

  static Future<CalendarService> create(DBService dbs, UserService us) async {
    Map<String, dynamic>? data =
        await dbs.getFromDB(path: 'calendars', data: '${us.user?.uid}');
    return CalendarService(
      dbs: dbs,
      us: us,
      calendar: Calendar.fromMap(data!),
      uid: us.user?.uid,
    );
  }

  Future<void> setAttendanceToDB(Map<String, String?> newAttendance) async {
    calendar.setAttendance(newAttendance);
    await dbs.addEntryToDBWithName(
        entry: calendar.getCalendarData(), path: 'calendars', name: uid!);
  }

  Future<void> setScheduledDaysToDB(List<String> newScheduledDays) async {
    calendar.setScheduledDays(newScheduledDays);
    await dbs.addEntryToDBWithName(
        entry: calendar.getCalendarData(), path: 'calendars', name: uid!);
  }

  // Getter for attendance
  Map<String, String?> get attendance => calendar.attendance;

  // Setter for attendance
  set attendance(Map<String, String?> newAttendance) {
    calendar.setAttendance(newAttendance);
  }

  // Getter for scheduledDays
  List<String> get scheduledDays => calendar.scheduledDays;

  // Setter for scheduledDays
  set scheduledDays(List<String> newScheduledDays) {
    calendar.setScheduledDays(newScheduledDays);
  }
}
