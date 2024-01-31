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
          return const CircularProgressIndicator();
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

  const CalendarView({Key? key, required this.eventController})
      : super(key: key);

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
              padding: const EdgeInsets.all(10.0), child: calendarActual()),
        ),
      ),
    );
  }

  Widget calendarActual() {
    return WeekView(
      controller: eventController,
      heightPerMinute: .7,
      hourIndicatorSettings: HourIndicatorSettings.none(),

      eventTileBuilder: _eventTileBuilder,
      fullDayEventBuilder: _fullDayEventBuilder,
      backgroundColor: const Color.fromARGB(255, 33, 33, 33), //gray[800]
      headerStyle: const HeaderStyle(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 33, 33, 33), //gray[800]
        ),
      ),
    );
  }

  Widget _eventTileBuilder(
    DateTime date,
    List<CalendarEventData> events,
    Rect boundary,
    DateTime start,
    DateTime end,
  ) {
    return Column(
      children: events.map((event) => _buildEventContainer(event)).toList(),
    );
  }

  Widget _fullDayEventBuilder(List<CalendarEventData> events, DateTime date) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventContainer(event);
      },
    );
  }

  Widget _buildEventContainer(CalendarEventData event) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[200],
          border: Border.all(color: Colors.blue),
        ),
        child: ListTile(
          title: Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // This ListTile will now only contain a title, but will still expand to fill the available space.
        ),
      ),
    );
  }
}
