import 'package:e_qiu_guidance/View/desktop_view/events_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/reserved_seats_desktop.dart';
import 'package:e_qiu_guidance/View/desktop_view/speakers_desktop.dart';
import 'package:e_qiu_guidance/View/mobile_view/events.dart';
import 'package:e_qiu_guidance/View/mobile_view/reserved_seats.dart';
import 'package:e_qiu_guidance/View/mobile_view/speakers.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_calendar.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_map.dart';
import 'package:e_qiu_guidance/responsive/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavBarController extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  int _currentTab = 0;

  final List<Widget> _screens = [
    const ResponsiveLayout(mobileBody: Events(), desktopBody: EventsDesktop()),
    const ResponsiveLayout(
      mobileBody: Speakers(),
      desktopBody: SpeakersDesktop(),
    ),
    const ViewMap(),
    const ResponsiveLayout(mobileBody: Seats(), desktopBody: SeatsDesktop()),
    const ViewCalendar(),
    
  ];

  final List<Widget> _desktopScreens = [
    const ResponsiveLayout(mobileBody: Events(), desktopBody: EventsDesktop()),
    const ResponsiveLayout(
      mobileBody: Speakers(),
      desktopBody: SpeakersDesktop(),
    ),
    const ResponsiveLayout(mobileBody: Seats(), desktopBody: SeatsDesktop()),
    const ViewCalendar(),
  ];

  set currentTab(int tab) {
    _currentTab = tab;
    notifyListeners();
  }

  int get currentTab => _currentTab;
  get currentScreen => _screens[_currentTab];
  get currenDesktoptScreen => _desktopScreens[_currentTab];
}
