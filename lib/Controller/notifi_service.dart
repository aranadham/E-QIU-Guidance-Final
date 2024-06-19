import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(
      initializationSettings,
    );

    tz_data.initializeTimeZones(); // Initialize time zone data
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'E-QIU Guidance',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime scheduledTime}) async {
    final scheduledTimeWithZone = tz.TZDateTime.from(scheduledTime, tz.local);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTimeWithZone,
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Global variable for notification ID, ensuring unique IDs across multiple function calls
  int globalNotificationId = 0;

// Function to schedule event notifications
  Future<void> scheduleEventNotification(String documentId) async {
    final eventsCollection = FirebaseFirestore.instance.collection("Events");
    DocumentSnapshot doc;

    // Try to fetch the document and handle exceptions
    try {
      doc = await eventsCollection.doc(documentId).get();
    } catch (e) {
      debugPrint("Error fetching event with ID $documentId: $e");
      return; // Exit early if there's an error
    }

    // Check if the document exists
    if (!doc.exists) {
      debugPrint("Event with ID $documentId not found");
      return; // Exit early if the event doesn't exist
    }

    final now = DateTime.now(); // Get current time
    var eventData = doc.data() as Map<String, dynamic>;

    // Try to extract and validate event data
    DateTime eventStartDate;
    try {
      eventStartDate = (eventData["Start Date"] as Timestamp).toDate();
    } catch (e) {
      debugPrint("Error extracting event start date: $e");
      return; // Exit if there's an error
    }

    var eventTitle = eventData['title'];
    var notificationTime = eventStartDate
        .subtract(const Duration(hours: 1)); // 1 hour before the event
    var notificationTime24 = eventStartDate
        .subtract(const Duration(hours: 24)); // 24 hours before the event

    if (notificationTime.isAfter(now)) {
      // Schedule only if the notification time is in the future
      try {
        int notificationId2 =
            globalNotificationId++; // Unique ID for the 1-hour notification

        await scheduleNotification(
          id: notificationId2,
          title: eventTitle,
          body: "Event is starting in 1 hour",
          scheduledTime: notificationTime,
        );
        debugPrint(
            "Scheduling notification for: $notificationTime for event $eventTitle with the id of $notificationId2"); // Debug message
      } catch (e) {
        debugPrint(
            "Error scheduling notification(s) for event $eventTitle: $e");
      }
    }
    if (notificationTime24.isAfter(now)) {
      try {
        int notificationId1 =
            globalNotificationId++; // Unique ID for the 24-hour notification

        await scheduleNotification(
          id: notificationId1,
          title: eventTitle,
          body: "Event is starting in 24 hours",
          scheduledTime: notificationTime24,
        );
        debugPrint(
            "Scheduling notification for: $notificationTime24 for event $eventTitle  with the id of $notificationId1"); // Debug message
      } catch (e) {
        debugPrint(
            "Error scheduling notification(s) for event $eventTitle: $e");
      }
    } else {
      debugPrint(
          "Event has already started or passed: $notificationTime or $notificationTime24");
    }
  }

  // Future showTest({
  //   required String title,
  //   required String body,
  // }) async{
  //   const AndroidNotificationDetails and = AndroidNotificationDetails(
  //       'channelId',
  //       'E-QIU Guidance',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     );
  //   const NotificationDetails det = NotificationDetails(android: and); 
  //   await notificationsPlugin.show(100, title, body, det);
  // }

  //method to send notification for all events
// Future<void> scheduleEventNotifications() async {
//     final eventsCollection = FirebaseFirestore.instance.collection("Events");

//     // Get all events
//     QuerySnapshot eventSnapshot = await eventsCollection.get();
//     if (eventSnapshot.docs.isEmpty) {
//       debugPrint("No events found");
//       return; // Exit early if no events
//     }

//     int notificationId = 0; // Used to uniquely identify notifications
//     final now = DateTime.now(); // Get current time

//     for (var doc in eventSnapshot.docs) {
//       var eventData = doc.data() as Map<String, dynamic>;
//       var eventStartDate = (eventData["Start Date"] as Timestamp).toDate();
//       var eventTitle = eventData['title'];
//       var notificationTime = eventStartDate
//           .subtract(const Duration(hours: 1)); // 1 hour before event

//       if (notificationTime.isAfter(now)) {
//         // Schedule only if the notification time is in the future
//         debugPrint(
//             "Scheduling notification for: $notificationTime"); // Debug message

//         await scheduleNotification(
//           id: notificationId,
//           title: eventTitle,
//           body: "Event is starting in 1 hour",
//           scheduledTime: notificationTime,
//         );

//         notificationId++; // Increment notification ID for unique identification
//       } else {
//         debugPrint("Skipping event as it's in the past: $notificationTime");
//       }
//     }
//   }
}
