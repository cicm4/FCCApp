import 'package:calendar_view/calendar_view.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/level_2/calendar_service.dart';
import 'package:flutter/material.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({super.key});

  @override
  State<CalendarHome> createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  final Future<List<CalendarEventData>> _eventsFuture =
      CalendarService.create(DBService(), UserService())
          .then((calendarService) {
    return calendarService.getEvents();
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CalendarEventData>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final events = snapshot.data!;
          final eventController = EventController()..addAll(events);

          return CalendarControllerProvider(
            controller: eventController,
            child: Scaffold(
              appBar: AppBar(
                shadowColor: Colors.grey[900],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  child: WeekView(
                    controller: eventController,

                    eventTileBuilder: (date, events, boundary, start, end) {
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Container(
                            height: 1000,
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 144, 202, 249)), //blue[200]
                            ),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  event.title,
                                  selectionColor: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    fullDayEventBuilder: (events, date) {
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                            ),
                            child: ListTile(
                              title: Text(event.title),
                              subtitle: Text(event.description),
                            ),
                          );
                        },
                      );
                    },
                    backgroundColor:
                        const Color.fromARGB(255, 33, 33, 33), //gray[800]
                    headerStyle: const HeaderStyle(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 33, 33, 33), //gray[800]
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
