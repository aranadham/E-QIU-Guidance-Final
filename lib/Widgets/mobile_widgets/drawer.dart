import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/drawer_controller.dart';

class StaffDrawer extends StatelessWidget {
  const StaffDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 106, 166),
            ),
            child: Center(
              child: Text(
                'Electronic QIU Guidance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text(
                'Add Events',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                Provider.of<StaffDrawerController>(context, listen: false)
                    .setIndex(0, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(
                'Manage Events',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                Provider.of<StaffDrawerController>(context, listen: false)
                    .setIndex(1, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text(
                'Register Staff',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                Provider.of<StaffDrawerController>(context, listen: false)
                    .setIndex(2, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text(
                'Register Student',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                Provider.of<StaffDrawerController>(context, listen: false)
                    .setIndex(3, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text(
                'Attendance',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                Provider.of<StaffDrawerController>(context, listen: false)
                    .setIndex(4, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                Provider.of<StaffDrawerController>(context, listen: false)
                    .setIndex(5, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
