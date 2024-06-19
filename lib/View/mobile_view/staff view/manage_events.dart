import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/edit_event_controller.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/manage_events_controller.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/view_event.dart';

class ManageEvents extends StatelessWidget {
  const ManageEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ManageEventsController>(context);
    final edit = Provider.of<EditEventsController>(context);
    final fetch = Provider.of<FetchController>(context);
    return Scaffold(
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/QIU wallpaper2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.9),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 150, horizontal: 40),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white, // Adjust opacity as needed
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: StreamBuilder(
                stream: fetch.fetchEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
            
                  if (snapshot.hasError) {
                    return const Text('No data');
                  }
            
                  List<Event> events = snapshot.data ?? [];
            
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      Event event = events[index];
                      String startDate = fetch.formatDateTime(event.startdate);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewEvent(
                                id: event.id,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(startDate),
                              Text(event.venue),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  edit.navigateToEdit(
                                    context: context,
                                    id: event.id,
                                    title: event.title,
                                    description: event.description,
                                    type: event.type,
                                    radio: event.visibility,
                                    venue: event.venue,
                                    
                                    startDateTime: event.toDateTimeObject(),
                                    endDateTime: event.toDateTimeObject1(),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm'),
                                        content: Text(
                                            'Are you sure you want to delete ${event.title}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              controller.deleteEvent(
                                                  context: context,
                                                  documentId: event.id);
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Success'),
                                                    content: const Text(
                                                        'Event deleted'),
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
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
