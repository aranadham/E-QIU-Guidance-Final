import 'package:e_qiu_guidance/View/desktop_view/view_speakers_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Controller/speaker_search_controller.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/search_field.dart';

class SpeakersDesktop extends StatelessWidget {
  const SpeakersDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    final search = Provider.of<SpeakerSearchController>(context);

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
              color: Colors.white, // Adjust opacity as needed
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                SearchField(
                  label: "Search by name",
                  onChanged: (query) {
                    search.updateQuery(query);
                  },
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: controller.fetchSpeakers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
            
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
            
                      List<Speaker> speakers = snapshot.data ?? [];
            
                      List<Speaker> filteredSpeakers =
                          search.filterSpeakers(speakers, search.query);
                      return ListView.builder(
                        itemCount: filteredSpeakers.length,
                        itemBuilder: (context, index) {
                          Speaker speaker = filteredSpeakers[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewSpeakerDesktop(id: speaker.id),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: const Icon(
                                Icons.person,
                                size: 35,
                              ),
                              title: Text(speaker.name),
                              subtitle: Text(speaker.description),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewSpeakerDesktop(id: speaker.id),
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
            ),
          ),
        ),
      ),
    );
  }
}
