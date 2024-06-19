import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/Model/events.dart';

class CalendarController extends ChangeNotifier {
  DateTime today = DateTime.now();
  late Map<DateTime, List<Event>> events;

  void daySelected(DateTime day, DateTime focusedDay) {
    today = DateTime(day.year, day.month, day.day);
    notifyListeners();
  }

  List getEventsForTheDay(DateTime day) {
    return events[day] ?? [];
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void loadFirestoreEvents() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.isAnonymous) {
      // If the user is anonymous, fetch only public events
      final snap = await FirebaseFirestore.instance
          .collection('Events')
          .where('visibility', isEqualTo: 'Public')
          .get();

      for (var doc in snap.docs) {
        Event event = Event.fromMap(doc.id, doc.data());
        DateTime day = event.toDateTimeObject();
        day = DateTime(day.year, day.month, day.day);
        if (events[day] == null) {
          events[day] = [];
        }
        events[day]!.add(event);
      }
    } else {
      // If the user is not anonymous, fetch all events
      final snap = await FirebaseFirestore.instance.collection('Events').get();

      for (var doc in snap.docs) {
        Event event = Event.fromMap(doc.id, doc.data());
        DateTime day = event.toDateTimeObject();
        day = DateTime(day.year, day.month, day.day);
        if (events[day] == null) {
          events[day] = [];
        }
        events[day]!.add(event);
      }
    }

    notifyListeners();
  }
}
