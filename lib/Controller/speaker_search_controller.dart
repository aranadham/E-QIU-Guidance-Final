import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';

class SpeakerSearchController extends ChangeNotifier {
  List<Speaker> filteredSpeakers = [];
  String query = '';

  List<Speaker> filterSpeakers(List<Speaker> allSpeakers, String query) {
    return filteredSpeakers = allSpeakers
        .where(
          (speaker) => speaker.name.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
  }

  void updateQuery(String query) {
    this.query = query;
    notifyListeners();
  }
}
