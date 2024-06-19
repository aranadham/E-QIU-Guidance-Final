import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/add_event_desktop.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/add_events.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/reserved_events.dart';
import 'package:e_qiu_guidance/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/manage_events.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/register_staff.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/register_student.dart';

class StaffDrawerController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  LogoutController logoutcontroller = LogoutController();
  void setIndex(int index, BuildContext context) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                mobileBody: AddEvents(),
                desktopBody: AddEventsDesktop(),
              ),
            ),
          );
          break;
        case 1:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ManageEvents()),
          );
          break;
        case 2:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterStaff()),
          );
          break;
        case 3:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterStudent()),
          );
          break;
        case 4:
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ReservedEvents(),
            ),
          );
          break;
        case 5:
          Navigator.pop(context);
          logoutcontroller.logout(context);
          break;

        default:
          break;
      }
    } else {
      Navigator.pop(context);
    }
  }
}
