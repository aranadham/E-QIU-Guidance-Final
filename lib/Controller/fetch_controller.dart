import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';

class FetchController extends ChangeNotifier {

    final User? _user = FirebaseAuth.instance.currentUser;
    get uid => _user!.uid;

  Stream<List<Event>> fetchEvents() {

    if (_user != null && _user!.isAnonymous) {
      return FirebaseFirestore.instance
          .collection("Events")
          .where('visibility', isEqualTo: 'Public')
          .orderBy("title")
          .snapshots()
          .map(
        (QuerySnapshot querySnapshot) {
          return querySnapshot.docs.map(
            (doc) {
              String documentId = doc.id;
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Event.fromMap(documentId, data);
            },
          ).toList();
        },
      );
    } else {
      return FirebaseFirestore.instance
          .collection("Events")
          .orderBy("title")
          .snapshots()
          .map(
        (QuerySnapshot querySnapshot) {
          return querySnapshot.docs.map(
            (doc) {
              String documentId = doc.id;
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Event.fromMap(documentId, data);
            },
          ).toList();
        },
      );
    }
  }

  Stream<Event?> fetchEvent({
    required String documentId,
  }) {
    return FirebaseFirestore.instance
        .collection("Events")
        .doc(documentId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String documentId = documentSnapshot.id;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return Event.fromMap(documentId, data);
      } else {
        return null;
      }
    });
  }

  Stream<List<Event>> fetchRelatedEvents(String documentId) {
    if (_user != null && _user!.isAnonymous) {
      return FirebaseFirestore.instance
          .collection('Speakers')
          .doc(documentId)
          .snapshots()
          .asyncMap(
        (DocumentSnapshot speakerSnapshot) async {
          List<String> eventRefs = [];

          if (speakerSnapshot.exists) {
            var data = speakerSnapshot.data() as Map<String, dynamic>;

            eventRefs = List<String>.from(data['eventRefs'] ?? []);
          }

          List<Event> events = [];

          for (String eventRef in eventRefs) {
            DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
                .collection('Events')
                .doc(eventRef)
                .get();

            if (eventSnapshot.exists) {
              var eventData = eventSnapshot.data() as Map<String, dynamic>;
              if (eventData['visibility'] == 'Public') {
                events.add(Event.fromMap(eventSnapshot.id, eventData));
              }
            }
          }

          return events;
        },
      );
    } else {
      // If the user is not anonymous, fetch all events related to the speaker
      return FirebaseFirestore.instance
          .collection('Speakers')
          .doc(documentId)
          .snapshots()
          .asyncMap(
        (DocumentSnapshot speakerSnapshot) async {
          List<String> eventRefs = [];

          if (speakerSnapshot.exists) {
            var data = speakerSnapshot.data() as Map<String, dynamic>;
            eventRefs = List<String>.from(data['eventRefs'] ?? []);
          }

          List<Event> events = [];

          for (String eventRef in eventRefs) {
            DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
                .collection('Events')
                .doc(eventRef)
                .get();

            if (eventSnapshot.exists) {
              var eventData = eventSnapshot.data() as Map<String, dynamic>;
              events.add(Event.fromMap(eventSnapshot.id, eventData));
            }
          }

          return events;
        },
      );
    }
  }

  Stream<List<Speaker>> fetchSpeakers() {
    return FirebaseFirestore.instance.collection("Speakers").snapshots().map(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          String documentId = doc.id;
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Speaker.fromMap(documentId, data);
        }).toList();
      },
    );
  }

  Stream<Speaker?> fetchSpeaker({
    required String documentId,
  }) {
    return FirebaseFirestore.instance
        .collection("Speakers")
        .doc(documentId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String documentId = documentSnapshot.id;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return Speaker.fromMap(documentId, data);
      } else {
        return null;
      }
    });
  }

  Stream<List<Speaker>> fetchRelatedSpeakers(String documentId) {
    return FirebaseFirestore.instance
        .collection("Events")
        .doc(documentId)
        .snapshots()
        .asyncMap(
      (DocumentSnapshot eventSnapshot) async {
        List<String> speakerRefs = [];

        if (eventSnapshot.exists) {
          var data = eventSnapshot.data() as Map<String, dynamic>;
          speakerRefs = List<String>.from(data['speakerRefs'] ?? []);
        }

        List<Speaker> speakers = [];

        for (String speakerRef in speakerRefs) {
          DocumentSnapshot speakerSnapshot = await FirebaseFirestore.instance
              .collection("Speakers")
              .doc(speakerRef)
              .get();
          if (speakerSnapshot.exists) {
            var speakerData = speakerSnapshot.data() as Map<String, dynamic>;
            speakers.add(Speaker.fromMap(speakerSnapshot.id, speakerData));
          }
        }
        return speakers;
      },
    );
  }

  Stream<List<Event>> fetchReservations() {
    try {
      // Reference to the reservations collection
      CollectionReference reservationsCollection =
          FirebaseFirestore.instance.collection('reservations');

      // Reference to the events collection
      CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('Events');

      return reservationsCollection
          .doc(uid)
          .collection('reservations')
          .snapshots()
          .asyncMap((reservationsQuery) async {
        // List to store Event models
        List<Event> eventsList = [];

        // Access the data from each document in the subcollection
        for (QueryDocumentSnapshot reservationDoc in reservationsQuery.docs) {
          // Get and store the document ID
          String documentId = reservationDoc.id;

          // Fetch events using document IDs
          DocumentSnapshot eventDoc =
              await eventsCollection.doc(documentId).get();
          if (eventDoc.exists) {
            // Convert the document data to an Event model
            Event event = Event.fromMap(
                documentId, eventDoc.data() as Map<String, dynamic>);
            eventsList.add(event);
          }
        }

        return eventsList;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return Stream.value([]); // Return an empty stream in case of an error
    }
  }

  Future<int> getReservedSeats(String userId, String eventId) async {
    try {
      // Access the subcollection
      DocumentSnapshot reservationQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('reservations')
          .doc(userId)
          .collection("reservations")
          .doc(eventId)
          .get();

      // Iterate through the documents in the subcollection and retrieve the 'reservedSeat' values
      var data = reservationQuerySnapshot.data() as Map<String, dynamic>;
      int reservedSeat = data['reservedSeat'];

      return reservedSeat;
    } catch (error) {
      debugPrint('Error retrieving reserved seat: $error');
      return 0; // Return an empty list or handle the error accordingly
    }
  }

  Stream<List<Event>> fetchEventsReserved() {
    return FirebaseFirestore.instance
        .collection("report")
        .snapshots()
        .asyncMap((snapshot) async {
      List<String> reportIds = snapshot.docs.map((doc) => doc.id).toList();

      List<Event> events = [];

      for (String reportId in reportIds) {
        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection("Events")
            .doc(reportId)
            .get();
        if (eventSnapshot.exists) {
          var eventData = eventSnapshot.data() as Map<String, dynamic>;
          events.add(Event.fromMap(eventSnapshot.id, eventData));
        }
      }

      return events;
    });
  }

  Stream<List<String>> generateReport(String reportId) {
    return FirebaseFirestore.instance
        .collection("report")
        .doc(reportId)
        .collection("reservations")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => (doc.data())["Name"] as String)
          .toList();
    });
  }

  Stream<int> fetchReservationCount(String reportId) {
    return FirebaseFirestore.instance
        .collection("report")
        .doc(reportId)
        .collection("reservations")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("dd/MM/yyyy HH:mm").format(dateTime);
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  String formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat("HH:mm").format(dateTime);
  }
}
