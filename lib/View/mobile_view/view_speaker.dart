import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_event.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/tile_text.dart';

class ViewSpeaker extends StatelessWidget {
  final String id;
  const ViewSpeaker({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speaker"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
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
            child: StreamBuilder(
              stream: controller.fetchSpeaker(documentId: id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  const Center(
                    child: Text("Speaker Not Found"),
                  );
                }

                Speaker? speaker = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    CustomText(value: speaker.name),
                    CustomText(value: speaker.description),
                    const SizedBox(
                      height: 40,
                    ),
                    const CustomText(value: "Related Sessions"),
                    Expanded(
                      child: StreamBuilder(
                        stream: controller.fetchRelatedEvents(speaker.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text("Loading...."),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          List<Event> events = snapshot.data ?? [];

                          return ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              Event event = events[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewEvents(id: event.id),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    event.title,
                                  ),
                                  subtitle: Text(
                                    event.venue,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewEvents(id: event.id),
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
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
