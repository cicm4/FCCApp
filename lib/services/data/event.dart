import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  bool work;

  Timestamp startTime;

  Timestamp endTime;

  int numWorking;

  List<String>? attendees;

  Event(
      {required this.work,
      required this.startTime,
      required this.endTime,
      required this.numWorking,
      this.attendees});

  Map<String, dynamic> toMap() => {
        'work': work,
        'startTime': startTime,
        'endTime': endTime,
        'numWorking': numWorking,
        'attendees': attendees,
      };

  //from Map
  factory Event.fromMap(Map<String, dynamic> data) => Event(
        work: data['work'] ?? false, // Assuming default values in case of null
        startTime: data['startTime']
            as Timestamp, // Type casting, consider error handling
        endTime: data['endTime'] as Timestamp,
        numWorking: data['numWorking'] ?? 0,
        attendees: List<String>.from(data['attendees'] ?? []),
      );
}
