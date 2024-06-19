import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id = "";
  String title = "";
  String description = "";
  String type = "";
  String visibility = "";
  String venue = "";
  Timestamp startdate = Timestamp.now();
  Timestamp enddate = Timestamp.now();
  String duration = "";
  List speakerRefs = [];
  int availableSeats = 0;
  int reservedSeats = 0;
  int seatCount = 0;

  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.type,
      required this.visibility,
      required this.venue,
      required this.startdate,
      required this.enddate,
      required this.duration,
      required this.speakerRefs,
      required this.availableSeats,
      required this.reservedSeats,
      required this.seatCount});

  Event.empty();

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      type: map['type'] ?? "",
      visibility: map['visibility'] ?? 0,
      venue: map['venue'] ?? "",
      startdate: map['Start Date'] ?? Timestamp.now(),
      enddate: map['End Date'] ?? Timestamp.now(),
      duration: map['Duration'] ?? "",
      speakerRefs: map['speakerRefs'] ?? [],
      availableSeats: map['availableSeats'] ?? 0,
      reservedSeats: map['reservedSeats'] ?? 0,
      seatCount: map['seat Count'] ?? 0,
    );
  }

  DateTime toDateTimeObject() {
    return startdate.toDate();
  }

  DateTime toDateTimeObject1() {
    return enddate.toDate();
  }
}
