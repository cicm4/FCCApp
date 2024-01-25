import 'package:cloud_firestore/cloud_firestore.dart';

class LocalEvent {
  bool work;

  Timestamp startTime;

  Timestamp endTime;

  int numWorking;

  List<String> attendees;

  LocalEvent(
      {required this.work,
      required this.startTime,
      required this.endTime,
      required this.numWorking,
      required this.attendees});

  Map<String, dynamic> toMap() => {
        'work': work,
        'startTime': startTime,
        'endTime': endTime,
        'numWorking': numWorking,
        'attendees': attendees,
      };

  //from Map
  factory LocalEvent.fromMap(Map<String, dynamic> data) => LocalEvent(
        work: data['work'] ?? false, // Assuming default values in case of null
        startTime: data['startTime']
            as Timestamp, // Type casting, consider error handling
        endTime: data['endTime'] as Timestamp,
        numWorking: data['numWorking'] ?? 0,
        attendees: List<String>.from(data['attendees'] ?? []),
      );
}
