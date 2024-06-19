import 'package:e_qiu_guidance/Controller/Staff_controllers/staff_nav_controller.dart';
import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffNavBar extends StatelessWidget {
  const StaffNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<StaffNavBarController>(context);
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
                  minWidth: 120,
                  selectedLabelTextStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  elevation: 10,
                  selectedIndex: controller.currentTab,
                  onDestinationSelected: (value) => controller.currentTab = value,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.add_outlined),
                      selectedIcon: Icon(Icons.add),
                      label: Text("Add Events"),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit_outlined),
                      selectedIcon: Icon(Icons.edit),
                      label: Text("Manage Events"),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_add_alt_1_outlined),
                      selectedIcon: Icon(Icons.person_add_alt_1),
                      label: Text("Register Staff"),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_add_alt_1_outlined),
                      selectedIcon: Icon(Icons.person_add_alt_1),
                      label: Text("Register Student"),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                     NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text("Attendance"),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ],
                ),
              Expanded(child: controller.currentScreen),
            ],
          ),
          bottomNavigationBar: MediaQuery.of(context).size.width < 640
              ? NavigationBarTheme(
                  data: NavigationBarThemeData(
                    indicatorColor: const Color.fromARGB(255, 0, 174, 239),
                    labelTextStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
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
                          icon: Icon(Icons.add_outlined),
                          selectedIcon: Icon(Icons.add),
                          label: "Add Events"),
                      const NavigationDestination(
                          icon: Icon(Icons.edit_outlined),
                          selectedIcon: Icon(Icons.edit),
                          label: "Manage Events"),
                      const NavigationDestination(
                          icon: Icon(Icons.person_add_alt_1_outlined),
                          selectedIcon: Icon(Icons.person_add_alt_1),
                          label: "Register Staff"),
                      const NavigationDestination(
                          icon: Icon(Icons.person_add_alt_1_outlined),
                          selectedIcon: Icon(Icons.person_add_alt_1),
                          label: "Register Student"),
                      const NavigationDestination(
                          icon: Icon(Icons.people_outline),
                          selectedIcon: Icon(Icons.people),
                          label: "Attendance"),
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
