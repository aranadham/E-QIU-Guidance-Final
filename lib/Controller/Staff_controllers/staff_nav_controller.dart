import 'package:e_qiu_guidance/View/desktop_view/staff%20view/add_event_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/manage_events_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/register_staff_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/register_student_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/staff%20view/reserved_events_dektop.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/add_events.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/manage_events.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/register_staff.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/register_student.dart';
import 'package:e_qiu_guidance/View/mobile_view/staff%20view/reserved_events.dart';
import 'package:e_qiu_guidance/responsive/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffNavBarController extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  int _currentTab = 0;

  final List<Widget> _screens = [
    const ResponsiveLayout(
        mobileBody: AddEvents(), desktopBody: AddEventsDesktop()),
    const ResponsiveLayout(
        mobileBody: ManageEvents(), desktopBody: ManageEventsDesktop()),
    const ResponsiveLayout(
        mobileBody: RegisterStaff(), desktopBody: RegisterStaffDesktop()),
    const ResponsiveLayout(
        mobileBody: RegisterStudent(), desktopBody: RegisterStudentDesktop()),
    const ResponsiveLayout(
        mobileBody: ReservedEvents(), desktopBody: ReservedEventsDesktop()),
  ];

  set currentTab(int tab) {
    _currentTab = tab;
    notifyListeners();
  }

  int get currentTab => _currentTab;
  get currentScreen => _screens[_currentTab];
}
