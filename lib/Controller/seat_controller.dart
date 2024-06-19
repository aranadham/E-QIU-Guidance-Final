// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_qiu_guidance/Controller/notifi_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SeatController extends ChangeNotifier {
  bool isReserved = false;

  

  Future<bool> doesCollectionExists(String userId, String eventId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(userId)
          .collection("reservations")
          .get();

      // Iterate through documents to check if any document ID matches eventId
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        if (docSnapshot.id == eventId) {
          return true;
        }
      }

      return false;
    } catch (error) {
      // Handle errors if needed
      return false;
    }
  }

  Future<void> checkReservationStatus(String eventId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Handle the case where the user is not authenticated
        return;
      }

      String userId = user.uid;

      // Check if the 'reservations/userId/eventId' collection exists
      bool doesCollectionExist = await doesCollectionExists(userId, eventId);

      isReserved = doesCollectionExist;
      notifyListeners();
    } catch (error) {
      // Handle errors if needed
    }
  }

  Future<void> report(String eventId, String userId, String name) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('report').doc(eventId).set({});

      await firestore
          .collection('report')
          .doc(eventId)
          .collection('reservations')
          .doc(userId)
          .set({
        "Name": name,
      });
    } catch (e) {
      debugPrint('Error adding report and reservations: $e');
    }
  }

  Future<void> reserveSeat(BuildContext context, String eventId) async {
    try {
      if (isReserved) {
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Handle the case where the user is not authenticated
        return;
      }

      String userId = user.uid;

      if (user.isAnonymous) {
        report(eventId, userId, "Guest");
      } else {
        report(eventId, userId, user.displayName!);
      }

      // Fetch the current seat count from the 'Events' collection
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection("Events")
          .doc(eventId)
          .get();

      int currentSeatCount = eventSnapshot['seat Count'] ?? 0;

      // Update seat count in the 'Events' collection
      await FirebaseFirestore.instance.collection("Events").doc(eventId).update(
        {
          'seat Count': FieldValue.increment(1),
        },
      );

      // Create a reservation document in the 'reservations' collection
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(userId)
          .collection("reservations")
          .doc(eventId)
          .set(
        {
          'eventId': eventId,
          'reservedSeat': currentSeatCount + 1,
        },
      );

      isReserved = true;
      notifyListeners();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "Seat Reserved Successfully Your Seat Number is: ${currentSeatCount + 1}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );

      NotificationService().scheduleEventNotification(eventId);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Something went wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
