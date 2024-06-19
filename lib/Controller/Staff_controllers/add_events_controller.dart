// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEventController extends ChangeNotifier {
  String title = "";
  String description = "";
  String selectedRadio = "";
  bool isSelected = true;
  String venue = "";
  DateTime selectedStartDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();
  List<Map<String, String>> speakersData = [
    {
      'Speaker': 'Speaker',
      'Description': 'Speaker Description',
    }
  ];
  int availableSeats = 0;
  int reservedSeats = 0;

  String? selectedEventType;

  List<String> eventTypes = [
    'Event Type',
    'Seminar',
    'Workshop',
  ];

  final ScrollController scrollController = ScrollController();

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setType(String value) {
    selectedEventType = value;
    notifyListeners();
  }

  void setSelectedRadio(String value) {
    isSelected = true;
    selectedRadio = value;
    notifyListeners();
  }

  void setVenue(String value) {
    venue = value;
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
      firstDate: DateTime.now(),
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

  void incrementNumberOfFields() {
    if (speakersData.length < 5) {
      speakersData.add({
        'Speaker': 'Speaker',
        'Description': 'Speaker Description',
      });
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

  void setAvailableSeats(int value) {
    availableSeats = value;
    notifyListeners();
  }

  void setReservedSeats(int value) {
    reservedSeats = value;
    notifyListeners();
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
    } else if (value.length < 11 || value.length >= 100) {
      return 'Event description should be between 11 and 100 characters';
    }
    return null;
  }

  String? validateEventType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select the event type';
    } else if (value == "Event Type") {
      return 'Please select the event type';
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

  Widget? validateVisibility() {
    return isSelected
        ? const Text("")
        : const Text(
            "Please select event visibility",
            style: TextStyle(color: Color.fromARGB(255, 172, 13, 2)),
          );
  }

  String? validateEventSpeaker(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the speaker name';
    } else if (value.length < 6 || value.length >= 10) {
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

  String? validateAvailableSeats(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    } else {
      int? parsedValue = int.tryParse(value);
      if (parsedValue == null) {
        return 'Please enter a valid integer';
      } else if (parsedValue == 1) {
        return 'Value should not be 1';
      }
    }
    return null;
  }

  String? validateReservedSeats(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    } else {
      int? parsedValue = int.tryParse(value);
      if (parsedValue == null) {
        return 'Please enter a valid integer';
      } else if (parsedValue == 1) {
        return 'Value should not be 1';
      }
    }
    return null;
  }

  Future<void> addEvent(BuildContext context) async {
    try {
      if (selectedStartDateTime != null && selectedEndDateTime != null) {
        Timestamp startdate = Timestamp.fromDate(selectedStartDateTime);
        Timestamp enddate = Timestamp.fromDate(selectedEndDateTime);

        DocumentReference eventRef =
            await FirebaseFirestore.instance.collection("Events").add(
          {
            'title': title,
            'description': description,
            'type': selectedEventType ?? 'none',
            'visibility': selectedRadio,
            'venue': venue,
            'Start Date': startdate,
            'End Date': enddate,
            'Duration': calculateEventDuration(),
            'availableSeats': availableSeats,
            'reservedSeats': reservedSeats,
            'seat Count': reservedSeats,
          },
        );
        await addSpeakers(eventRef);

        title = "";
        description = "";
        selectedEventType = "Event Type";
        selectedRadio = "";
        venue = "";
        selectedStartDateTime = DateTime.now();
        selectedEndDateTime = DateTime.now();
        availableSeats = 0;
        reservedSeats = 0;
        speakersData = [
          {
            'Speaker': 'Speaker',
            'Description': 'Speaker Description',
          }
        ];
        notifyListeners();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Event added successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
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
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> addSpeakers(DocumentReference eventRef) async {
    List speakerRefs = [];

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

        // Update the existing speaker with the new event reference
        await existingSpeakerRef.update({
          'eventRefs': FieldValue.arrayUnion([eventRef.id]),
        });

        // Add the existing speaker reference to the list
        speakerRefs.add(existingSpeakerRef.id);
      } else {
        // Create a new speaker
        DocumentReference speakerRef =
            await FirebaseFirestore.instance.collection("Speakers").add(
          {
            'Speaker Name': speaker['Speaker'],
            'Speaker Description': speaker['Description'],
            'eventRefs': [
              eventRef.id
            ], // Initialize with the current event reference
          },
        );

        // Add the new speaker reference to the list
        speakerRefs.add(speakerRef.id);
      }
    }

    // Update the event document with the list of speaker references
    await eventRef.update({'speakerRefs': speakerRefs});
  }
}
