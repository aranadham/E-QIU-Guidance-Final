import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/attendance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservedEvents extends StatelessWidget {
  const ReservedEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/QIU wallpaper2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.9),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: StreamBuilder<List<Event>>(
              stream: controller.fetchEventsReserved(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                List<Event> events = snapshot.data ?? [];
                if (events.isEmpty) {
                  return const Center(
                    child: Text('No events found.'),
                  );
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Attendance(reportId: event.id),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Attendance(reportId: event.id),
                              ),
                            );
                          },
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
    );
  }
}
