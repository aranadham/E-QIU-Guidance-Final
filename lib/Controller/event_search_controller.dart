import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/Model/events.dart';

class EventSearchController extends ChangeNotifier {
  List<Event> filteredEvents = [];
  String query = '';

  List<Event> filterEvents(List<Event> allEvents, String query) {
    return filteredEvents = allEvents
        .where(
            (event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateQuery(String query) {
    this.query = query;
    notifyListeners();
  }
}
