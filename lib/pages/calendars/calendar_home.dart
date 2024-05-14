import 'package:calendar_view/calendar_view.dart';
import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';
import 'package:fccapp/services/level_2/calendar_service.dart';
import 'package:fccapp/shared/loading.dart';
import 'package:flutter/material.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({super.key});

  @override
  State<CalendarHome> createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  late final Future<List<CalendarEventData>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _initEvents();
  }

  void _initEvents() {
    _eventsFuture = CalendarService.create(DBService(), UserService()).then(
      (calendarService) => calendarService.getEvents(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CalendarEventData>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final events = snapshot.data ?? [];
        final eventController = EventController()..addAll(events);

        return CalendarView(eventController: eventController);
      },
    );
  }
}

class CalendarView extends StatelessWidget {
  final EventController eventController;

  const CalendarView({super.key, required this.eventController});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: eventController,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.grey[900],
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: calendarActual(context)),
        ),
      ),
    );
  }

  Widget calendarActual(BuildContext context) {
    return WeekView(
      controller: eventController,
      heightPerMinute: .7,
      hourIndicatorSettings: HourIndicatorSettings.none(),
      eventTileBuilder: (date, events, boundary, start, end) {
        // Inline builder logic here, with access to context
        return Column(
          children: events
              .map((event) => _buildEventContainer(context, event))
              .toList(),
        );
      },
      fullDayEventBuilder: (events, date) {
        // Inline builder logic here, with access to context
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventContainer(context, event);
          },
        );
      },
      backgroundColor: const Color.fromARGB(255, 33, 33, 33), //gray[800]
      headerStyle: const HeaderStyle(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 33, 33, 33), //gray[800]
        ),
      ),
    );
  }

  Widget _buildEventContainer(BuildContext context, CalendarEventData event) {
    int time =
        event.endTime!.getTotalMinutes - event.startTime!.getTotalMinutes;
    const double heightPerMinute = 0.7;

    const int paddingHeight = 8;

    final double containerHeight = (time * heightPerMinute) - paddingHeight;

    return GestureDetector(
      onTap: () => _showEventDetailsBottomSheet(context, event),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        height: containerHeight,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _showEventDetailsBottomSheet(
      BuildContext context, CalendarEventData event) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(event.title),
                  onTap: () => {}),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Confirm Attendance'),
                onTap: () {
                  // Handle attendance confirmation here
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Look for a Replacement'),
                onTap: () {
                  // Handle looking for a replacement here
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
