import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/event_search_controller.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_seat.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/search_field.dart';

class Seats extends StatelessWidget {
  const Seats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    final search = Provider.of<EventSearchController>(context);

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
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Adjust opacity as needed
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
                    stream: controller.fetchReservations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      if (!snapshot.hasData) {
                        const Center(
                          child: Text("Your reservations will appear here"),
                        );
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

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewSeat(
                                    userId: controller.uid,
                                    eventId: event.id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ListTile(
                                title: Text(event.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(startDate),
                                    Text(event.venue),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewSeat(
                                          userId: controller.uid,
                                          eventId: event.id,
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
}
