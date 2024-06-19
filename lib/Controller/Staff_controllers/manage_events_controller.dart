// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ManageEventsController extends ChangeNotifier {
  Future<void> deleteEvent({
    required BuildContext context,
    required String documentId,
  }) async {
    try {
      // Step 1: Delete the event from the "Events" collection
      await FirebaseFirestore.instance
          .collection("Events")
          .doc(documentId)
          .delete();

      // Step 2: Retrieve the list of speakers referencing the deleted event
      QuerySnapshot speakersSnapshot = await FirebaseFirestore.instance
          .collection("Speakers")
          .where("eventRefs", arrayContains: documentId)
          .get();

      // Step 3: Update each speaker document to remove the deleted event reference
      for (QueryDocumentSnapshot speakerDoc in speakersSnapshot.docs) {
        List<String> eventRefs = List<String>.from(speakerDoc["eventRefs"]);
        eventRefs.remove(documentId);

        // Update the speaker document
        await FirebaseFirestore.instance
            .collection("Speakers")
            .doc(speakerDoc.id)
            .update({"eventRefs": eventRefs});

        if (eventRefs.isEmpty) {
          await FirebaseFirestore.instance
              .collection("Speakers")
              .doc(speakerDoc.id)
              .delete();
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error deleting event: $error"),
      ));
    }
  }

}
