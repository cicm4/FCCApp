import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/data/localEvent.dart';
import 'package:fccapp/services/level_2/calendar_service.dart';
import 'package:flutter/foundation.dart';

class EventService {
  DBService dbs;
  Map<String, LocalEvent> events;

  EventService({required this.dbs, required this.events});

  Future<void> getEventsInUserCalendar(CalendarService cs) async {
    //loops over every event in the calendarService and looks for them in DBService in the events section, then adds them to the events list as new Events
    try {
      for (String event in cs.calendar.scheduledDays) {
        dbs.getFromDB(path: 'events', data: event).then((value) {
          events
              .addAll(<String, LocalEvent>{event: LocalEvent.fromMap(value!)});
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  LocalEvent? getEventByName(String name) {
    try {
      return events[name];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
