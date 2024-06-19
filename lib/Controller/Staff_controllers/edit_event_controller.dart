// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/edit_event_desktop.dart';
import 'package:e_qiu_guidance/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/edit_event.dart';

class EditEventsController extends ChangeNotifier {
  String id = "";
  String title = "";
  String description = "";
  String type = "";
  String selectedRadio = "";
  String venue = "";
  List<Map<String, dynamic>> speakersData = [];
  DocumentReference? eventRef;
  DateTime selectedStartDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();
  List<String> eventTypes = [
    'Seminar',
    'Workshop',
  ];

  Future<List<Map<String, dynamic>>> fetchRelatedSpeakers(
      String documentId) async {
    // Fetch the event document from Firestore.
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection("Events")
        .doc(documentId)
        .get();

    List<String> speakerRefs = [];

    // Check if the event document exists and extract the speaker references.
    if (eventSnapshot.exists) {
      var data = eventSnapshot.data() as Map<String, dynamic>;
      speakerRefs = List<String>.from(data['speakerRefs'] ?? []);
    }

    List<Map<String, dynamic>> speakerMaps = [];

    // Retrieve the corresponding speaker documents based on references.
    for (String speakerRef in speakerRefs) {
      DocumentSnapshot speakerSnapshot = await FirebaseFirestore.instance
          .collection("Speakers")
          .doc(speakerRef)
          .get();

      if (speakerSnapshot.exists) {
        var speakerData = speakerSnapshot.data() as Map<String, dynamic>;

        // Create a Speaker object using Speaker.fromMap.
        Speaker speaker = Speaker.fromMap(speakerSnapshot.id, speakerData);

        // Convert the Speaker object to a map using Speaker.toMap.
        Map<String, dynamic> speakerMap = speaker.toMap();

        // Add to the list of speaker maps.
        speakerMaps.add(speakerMap);
      }
    }

    return speakerMaps; // Return the list of speaker maps.
  }

  void navigateToEdit({
    required BuildContext context,
    required String id,
    required String title,
    required String description,
    required String type,
    required String radio,
    required String venue,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) async {
    this.id = id;
    this.title = title;
    this.description = description;
    this.type = type;
    selectedRadio = radio;
    this.venue = venue;
    speakersData = await fetchRelatedSpeakers(id);
    selectedStartDateTime = startDateTime;
    selectedEndDateTime = endDateTime;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileBody: EditEvent(),
          desktopBody: EditEventDesktop(),
        ),
      ),
    );
  }

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  void setSelectedRadio(String value) {
    selectedRadio = value;
    notifyListeners();
  }

  void setVenue(String value) {
    venue = value;
    notifyListeners();
  }

  void incrementNumberOfFields() {
    if (speakersData.length < 5) {
      speakersData.add({});
      notifyListeners();
    }
  }

  void decrementNumberOfFields() {
    if (speakersData.length > 1) {
      speakersData.removeLast();
      notifyListeners();
    }
  }

  void setSpeaker(int index, String value) {
    speakersData[index]['Speaker'] = value;
    notifyListeners();
  }

  void setSpeakerDescription(int index, String value) {
    speakersData[index]['Description'] = value;
    notifyListeners();
  }

  void pickStartTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) {
        if (value != null) {
          if (selectedStartDateTime != null) {
            selectedStartDateTime = DateTime(
              selectedStartDateTime.year,
              selectedStartDateTime.month,
              selectedStartDateTime.day,
              value.hour,
              value.minute,
            );
          } else {
            // Handle case where pickDate hasn't been called yet
            selectedStartDateTime = DateTime.now();
          }

          notifyListeners();
        }
      },
    );
  }

  void pickStartDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then(
      (value) {
        if (value != null) {
          // Combine date and time
          if (selectedStartDateTime != null) {
            selectedStartDateTime = DateTime(
              value.year,
              value.month,
              value.day,
              selectedStartDateTime.hour,
              selectedStartDateTime.minute,
            );
          } else {
            // Handle case where pickTime hasn't been called yet
            selectedStartDateTime = value;
          }

          notifyListeners();
        }
      },
    );
  }

  void pickEndTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) {
        if (value != null) {
          if (selectedEndDateTime != null) {
            selectedEndDateTime = DateTime(
              selectedEndDateTime.year,
              selectedEndDateTime.month,
              selectedEndDateTime.day,
              value.hour,
              value.minute,
            );
          } else {
            // Handle case where pickDate hasn't been called yet
            selectedEndDateTime = DateTime.now();
          }

          notifyListeners();
        }
      },
    );
  }

  void pickEndDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    ).then(
      (value) {
        if (value != null) {
          // Combine date and time
          if (selectedEndDateTime != null) {
            selectedEndDateTime = DateTime(
              value.year,
              value.month,
              value.day,
              selectedEndDateTime.hour,
              selectedEndDateTime.minute,
            );
          } else {
            // Handle case where pickTime hasn't been called yet
            selectedEndDateTime = value;
          }

          notifyListeners();
        }
      },
    );
  }

  String calculateEventDuration() {
    final Duration duration =
        selectedEndDateTime.difference(selectedStartDateTime);
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    return "$hours hour(s) $minutes minutes";
  }

  String? validateEventTitle(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event title';
    } else if (value.length < 6 || value.length > 30) {
      return 'Event title should be between 6 and 30 characters';
    }
    return null;
  }

  String? validateEventDescription(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event description';
    } else if (value.length < 11 || value.length > 100) {
      return 'Event description should be between 11 and 100 characters';
    }
    return null;
  }

  String? validateEventType(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event type';
    } else if (value.length < 5 || value.length > 20) {
      return 'Event type should be between 5 and 20 characters';
    }
    return null;
  }

  String? validateEventVenue(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the event venue';
    } else if (value.length < 2 || value.length > 6) {
      return 'Event venue should be between 2 and 6 characters';
    }
    return null;
  }

  String? validateEventSpeaker(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the speaker name';
    } else if (value.length < 6 || value.length > 10) {
      return 'Speaker name should be between 6 and 10 characters';
    }
    return null;
  }

  String? validateEventSpeakerDescription(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the speaker description';
    } else if (value.length < 11 || value.length > 50) {
      return 'Speaker description should be between 11 and 50 characters';
    }
    return null;
  }

  Future<void> updateEvent(BuildContext context) async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Updateing...",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (selectedStartDateTime != null && selectedEndDateTime != null) {
        Timestamp startdate = Timestamp.fromDate(selectedStartDateTime);
        Timestamp enddate = Timestamp.fromDate(selectedEndDateTime);
        await FirebaseFirestore.instance.collection("Events").doc(id).update(
          {
            'title': title,
            'description': description,
            'type': type,
            'visibility': selectedRadio,
            'venue': venue,
            'Start Date': startdate,
            'End Date': enddate,
            'Duration': calculateEventDuration(),
          },
        );

        await updateSpeakers(id);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Event updated successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('some thing went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> updateSpeakers(String eventRef) async {
    List<String> speakerRefs = []; // List to store updated speaker references

    for (var speaker in speakersData) {
      // Check if a speaker with the same name already exists
      QuerySnapshot existingSpeakers = await FirebaseFirestore.instance
          .collection("Speakers")
          .where('Speaker Name', isEqualTo: speaker['Speaker'])
          .limit(1)
          .get();

      if (existingSpeakers.docs.isNotEmpty) {
        // Use the existing speaker if found
        DocumentReference existingSpeakerRef =
            existingSpeakers.docs.first.reference;

        // Update the existing speaker with the new event reference and updated description
        await existingSpeakerRef.update({
          'Speaker Description': speaker['Description'], // Updated description
        });

        // Add the existing speaker reference to the list
        speakerRefs.add(existingSpeakerRef.id);
      } else {
        // Create a new speaker if none exists with the same name
        DocumentReference newSpeakerRef =
            await FirebaseFirestore.instance.collection("Speakers").add(
          {
            'Speaker Name': speaker['Speaker'],
            'Speaker Description': speaker['Description'],
            'eventRefs': [
              eventRef
            ], // Initialize with the current event reference
          },
        );

        // Add the new speaker reference to the list
        speakerRefs.add(newSpeakerRef.id);
      }
    }

    // Update the event document with the list of updated/new speaker references
    await FirebaseFirestore.instance
        .collection("Events")
        .doc(eventRef)
        .update({'speakerRefs': speakerRefs});
  }

  Future<void> removeSpeakerFromFirebase(
    int index,
    String speakerRef,
  ) async {
    // Get references to the Event and Speaker documents
    final eventReference =
        FirebaseFirestore.instance.collection('Events').doc(id);
    final speakerReference =
        FirebaseFirestore.instance.collection('Speakers').doc(speakerRef);

    // Remove the speaker from the Event
    eventReference.update({
      'speakerRefs': FieldValue.arrayRemove([speakerRef]),
    });

    // Remove the event from the Speaker
    speakerReference.update({
      'eventRefs': FieldValue.arrayRemove([id]),
    });

    // Check if `eventRefs` in the speaker document is empty
    final speakerDoc = await speakerReference.get();
    final eventRefs = speakerDoc['eventRefs'] as List<dynamic>?;

    if (eventRefs == null || eventRefs.isEmpty) {
      // If `eventRefs` is empty, delete the Speaker document
      await speakerReference.delete();
    }

    // Remove the speaker from your local list and notify listeners
    speakersData.removeAt(index);
    notifyListeners(); // Notify that the list has changed
  }
}
