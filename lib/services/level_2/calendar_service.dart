import 'package:calendar_view/calendar_view.dart';
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

  // Setter for attendance
  set attendance(Map<String, String?> newAttendance) {
    calendar.setAttendance(newAttendance);
  }

  // Setter for scheduledDays
  set scheduledDays(List<String> newScheduledDays) {
    calendar.setScheduledDays(newScheduledDays);
  }

  List<CalendarEventData> getEvents() {
    List<CalendarEventData> eventsList = [];
    calendar.attendance.forEach((key, value) {
      //the key encodes the date: 'DDMMYYYY'
      int day = int.parse(key.substring(0, 2));
      int month = int.parse(key.substring(2, 4));
      int year = int.parse(key.substring(4, 8));
      //then get the start and end times, this is based on the last letter of the name: 'M' is morning (8AM to 2PM), 'A' is afternoon (2PM to 8PM)
      String lastLetter = key.substring(key.length - 1);
      //case swich for the last letter
      switch (lastLetter) {
        case 'M':
          eventsList.add(CalendarEventData(
            date: DateTime(year, month, day),
            startTime: DateTime(year, month, day, 8),
            endTime: DateTime(year, month, day, 14),
            title: 'turno',
            description: 'Morning shift',
          ));
          break;
        case 'A':
          eventsList.add(CalendarEventData(
            date: DateTime(year, month, day),
            startTime: DateTime(year, month, day, 14),
            endTime: DateTime(year, month, day, 20),
            title: 'turno',
            description: 'Afternoon shift',
          ));
          break;
        default:
          eventsList.add(CalendarEventData(
            date: DateTime(year, month, day),
            startTime: DateTime(year, month, day, 8),
            endTime: DateTime(year, month, day, 20),
            title: 'turno',
            description: 'All day event',
          ));
          break;
      }
    });
    return eventsList;
  }
}
