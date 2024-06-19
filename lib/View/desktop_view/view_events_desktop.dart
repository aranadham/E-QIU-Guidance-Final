import 'package:e_qiu_guidance/View/desktop_view/view_speakers_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/seat_controller.dart';
import 'package:e_qiu_guidance/Model/events.dart';
import 'package:e_qiu_guidance/Model/speaker.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/tile_text.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';

class ViewEventsDesktop extends StatefulWidget {
  final String id;
  const ViewEventsDesktop({
    super.key,
    required this.id,
  });

  @override
  State<ViewEventsDesktop> createState() => _ViewEventsDesktopState();
}

class _ViewEventsDesktopState extends State<ViewEventsDesktop> {
  @override
  void initState() {
    super.initState();

    SeatController seatController =
        Provider.of<SeatController>(context, listen: false);

    seatController.checkReservationStatus(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);
    final seat = Provider.of<SeatController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event"),
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
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 220),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Adjust opacity as needed
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: StreamBuilder(
              stream: controller.fetchEvent(documentId: widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                Event? event = snapshot.data!;
                String startDate = controller.formatDateTime(event.startdate);
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: Text(
                          event.title,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTile(
                        label: "Venue",
                        value: event.venue,
                      ),
                      CustomTile(label: "Date and Time", value: startDate),
                      CustomTile(label: "Duration", value: event.duration),
                      const CustomText(value: "Event Description"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Wrap(
                          children: [
                            Text(
                              event.description,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const CustomText(value: "Speaker(s)"),
                      SizedBox(
                        height: 200,
                        child: StreamBuilder(
                          stream: controller.fetchRelatedSpeakers(event.id),
                          builder: (context, speakersSnapshot) {
                            if (speakersSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text("Loading...."),
                              );
                            }

                            if (speakersSnapshot.hasError) {
                              return Text('Error: ${speakersSnapshot.error}');
                            }

                            List<Speaker>? speakersData =
                                speakersSnapshot.data!;

                            return ListView.builder(
                              itemCount: speakersData.length,
                              itemBuilder: (context, index) {
                                Speaker speaker = speakersData[index];
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
                                    leading: Text(
                                      "${index + 1}",
                                      style: const TextStyle(fontSize: 30),
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
                      Center(
                        child: Btn(
                          text: "Register",
                          onPressed: () async {
                            if (event.seatCount < event.availableSeats) {
                              await seat.reserveSeat(context, event.id);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        "Sorry All Seats Are Taken!"),
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
                            }
                          },
                          isDisabled: seat.isReserved,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
