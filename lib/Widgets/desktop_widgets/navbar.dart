import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/add_event_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/manage_events_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/register_staff_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/register_student_desktop.dart';
import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  NavBar({super.key});

  final LogoutController logoutcontroller = LogoutController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEventsDesktop(),
                ));
          },
          child: const Text(
            "Add Events",
            style: TextStyle(color: white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageEventsDesktop(),
                ));
          },
          child: const Text(
            "Manage Events",
            style: TextStyle(color: white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterStudentDesktop(),
                ));
          },
          child: const Text(
            "Register Student",
            style: TextStyle(color: white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterStaffDesktop(),
                ));
          },
          child: const Text(
            "Register Staff",
            style: TextStyle(color: white),
          ),
        ),
        TextButton(
          onPressed: () {
            logoutcontroller.logout(context);
          },
          child: const Text(
            "Logout",
            style: TextStyle(color: white),
          ),
        ),
      ],
    );
  }
}
