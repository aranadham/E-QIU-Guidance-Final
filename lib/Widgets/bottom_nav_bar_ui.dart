import 'package:e_qiu_guidance/Controller/bottom_nav_bar.dart';
import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BottomNavBarController>(context);
    final logoutcontroller = Provider.of<LogoutController>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Row(
            children: [
              if (MediaQuery.of(context).size.width >= 640)
                NavigationRail(
                  leading: Image.asset(
                    "assets/qiu2.png",
                    height: 90,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content:
                                  const Text("Are you sure you want to logout"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "cancel",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    logoutcontroller.logout(context);
                                  },
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  indicatorColor: const Color.fromARGB(255, 0, 174, 239),
                  labelType: NavigationRailLabelType.selected,
                  selectedLabelTextStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  elevation: 10,
                  selectedIndex: controller.currentTab,
                  onDestinationSelected: (value) => controller.currentTab = value,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.event_outlined),
                      selectedIcon: Icon(Icons.event),
                      label: Text("Events"),
                      padding: EdgeInsets.symmetric(vertical: 32),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outlined),
                      selectedIcon: Icon(Icons.person),
                      label: Text("Speakers"),
                      padding: EdgeInsets.symmetric(vertical: 32),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chair_outlined),
                      selectedIcon: Icon(Icons.chair),
                      label: Text("Seats"),
                      padding: EdgeInsets.symmetric(vertical: 32),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today_outlined),
                      selectedIcon: Icon(Icons.calendar_today),
                      label: Text("Calendar"),
                      padding: EdgeInsets.symmetric(vertical: 32),
                    ),
                  ],
                ),
              Expanded(
                  child: MediaQuery.of(context).size.width >= 640
                      ? controller.currenDesktoptScreen
                      : controller.currentScreen),
            ],
          ),
          bottomNavigationBar: MediaQuery.of(context).size.width < 640
              ? NavigationBarTheme(
                  data: NavigationBarThemeData(
                    indicatorColor: const Color.fromARGB(255, 0, 174, 239),
                    labelTextStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  child: NavigationBar(
                    elevation: 10,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.onlyShowSelected,
                    animationDuration: const Duration(seconds: 1),
                    selectedIndex: controller.currentTab,
                    onDestinationSelected: (value) =>
                        controller.currentTab = value,
                    destinations: [
                      const NavigationDestination(
                          icon: Icon(Icons.event_outlined),
                          selectedIcon: Icon(Icons.event),
                          label: "Events"),
                      const NavigationDestination(
                          icon: Icon(Icons.person_outlined),
                          selectedIcon: Icon(Icons.person),
                          label: "Speakers"),
                      const NavigationDestination(
                          icon: Icon(Icons.map_outlined),
                          selectedIcon: Icon(Icons.map),
                          label: "Map"),
                      const NavigationDestination(
                          icon: Icon(Icons.chair_outlined),
                          selectedIcon: Icon(Icons.chair),
                          label: "Seats"),
                      const NavigationDestination(
                          icon: Icon(Icons.calendar_today_outlined),
                          selectedIcon: Icon(Icons.calendar_today),
                          label: "Calendar"),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you want to logout"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "cancel",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        logoutcontroller.logout(context);
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.logout))
                    ],
                  ),
                )
              : null),
    );
  }
}
