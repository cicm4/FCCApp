import 'package:calendar_view/calendar_view.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/Level_1/db_user_service.dart';
import 'package:fccapp/services/data/calendar.dart';
import 'package:fccapp/services/data/personalEvent.dart';
import 'package:flutter/foundation.dart';

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

  Future<bool> updateStatusInDB(int status, String event) async {
    try {
      calendar.attendance[event]!['status'] = status;
      return await dbs.addEntryToDBWithName(
          entry: calendar.getCalendarData(), path: 'calendars', name: uid!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }

  Future<void> setScheduledDaysToDB(
      List<PersonalEvent> newScheduledDays) async {
    calendar.setAttendanceFromList(newScheduledDays);
    await dbs.addEntryToDBWithName(
        entry: calendar.getCalendarData(), path: 'calendars', name: uid!);
  }

  // Setter for attendance
  set attendance(Map<String, String?> newAttendance) {
    calendar.setAttendance(newAttendance);
  }

  // Setter for scheduledDays

  List<CalendarEventData> getEvents() {
    List<CalendarEventData> eventsList = [];
    calendar.attendance.forEach((key, value) {
      //the key encodes the date: 'DDMMYYYY'
      int day = int.parse(key.substring(0, 2));
      int month = int.parse(key.substring(2, 4));
      int year = int.parse(key.substring(4, 8));

      print('day: $day, month: $month, year: $year');
      int startHour = value['start'];
      int endHour = value['end'];
      //case swich for the last letter
      eventsList.add(CalendarEventData(
        date: DateTime(year, month, day),
        startTime: DateTime(year, month, day, startHour),
        endTime: DateTime(year, month, day, endHour),
        title: 'turno',
      ));
    });
    return eventsList;
  }
}
