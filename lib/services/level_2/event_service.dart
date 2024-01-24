import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/data/event.dart';
import 'package:fccapp/services/level_2/calendar_service.dart';

class EventService {
  DBService dbs;
  List<Event> events;

  EventService({required this.dbs, required this.events});

  getEventsInUserCalendar(CalendarService cs) {
    //loops over every event in the calendarService and looks for them in DBService in the events section, then adds them to the events list as new Events
    for (String event in cs.calendar.scheduledDays) {
      dbs.getFromDB(path: 'events', data: event).then((value) {
        events.add(Event.fromMap(value!));
      });
    }
  }
}
