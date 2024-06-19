import 'package:e_qiu_guidance/View/desktop_view/events_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/speakers_desktop.dart';
import 'package:e_qiu_guidance/View/mobile_view/reserved_seats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_calendar.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_map.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/box.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    final logoutcontroller = Provider.of<LogoutController>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              logoutcontroller.logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/uni2.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  Box(
                    icon: Icons.map,
                    text: "Campus Map",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewMap(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.event,
                    text: "Events",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventsDesktop(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.person,
                    text: "Speakers",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpeakersDesktop(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.chair,
                    text: "Seat",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Seats(),
                        ),
                      );
                    },
                  ),
                  Box(
                    icon: Icons.calendar_today,
                    text: "Calendar",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewCalendar(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
