import 'package:e_qiu_guidance/View/desktop_view/view_events_desktop.dart';
import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Controller/event_search_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/search_field.dart';

class EventsDesktop extends StatefulWidget {
  const EventsDesktop({super.key});

  @override
  State<EventsDesktop> createState() => _EventsDesktopState();
}

class _EventsDesktopState extends State<EventsDesktop> {
  late final FetchController controller;
  late final EventSearchController search;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!controllerInitialized) {
      controller = Provider.of<FetchController>(context);
      search = Provider.of<EventSearchController>(context);
      controllerInitialized = true;
    }
  }

  bool controllerInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/QIU wallpaper2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.9),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 280),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                SearchField(
                  label: "Search by event name",
                  onChanged: (query) {
                    search.updateQuery(query);
                  },
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: controller.fetchEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
            
                      if (snapshot.hasError) {
                        return const Text('No data');
                      }
            
                      List<Event> events = snapshot.data ?? [];
            
                      List<Event> filteredEvents =
                          search.filterEvents(events, search.query);
            
                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          Event event = filteredEvents[index];
                          String startDate =
                              controller.formatDateTime(event.startdate);
            
                          Color tileColor = tileColors[index % tileColors.length];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewEventsDesktop(
                                    id: event.id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ListTile(
                                leading: Icon(
                                  Icons.event,
                                  size: 45,
                                  color: tileColor,
                                ),
                                title: Text(
                                  event.title,
                                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      startDate,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      event.venue,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: tileColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewEventsDesktop(
                                          id: event.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    search.query = "";
  }
}
