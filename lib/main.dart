import 'package:e_qiu_guidance/Controller/Staff_controllers/add_events_controller.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/drawer_controller.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/edit_event_controller.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/manage_events_controller.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/register_controller.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/staff_nav_controller.dart';
import 'package:e_qiu_guidance/Controller/bottom_nav_bar.dart';
import 'package:e_qiu_guidance/Controller/calendar_controller.dart';
import 'package:e_qiu_guidance/Controller/event_search_controller.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:e_qiu_guidance/Controller/login_controller.dart';
import 'package:e_qiu_guidance/Controller/logout_controller.dart';
import 'package:e_qiu_guidance/Controller/notifi_service.dart';
import 'package:e_qiu_guidance/Controller/seat_controller.dart';
import 'package:e_qiu_guidance/Controller/speaker_search_controller.dart';
import 'package:e_qiu_guidance/View/desktop_view/login_desktop.dart';
import 'package:e_qiu_guidance/View/mobile_view/login.dart';
import 'package:e_qiu_guidance/responsive/responsive_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Locking the app in portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => StaffDrawerController()),
        ChangeNotifierProvider(create: (_) => AddEventController()),
        ChangeNotifierProvider(create: (_) => ManageEventsController()),
        ChangeNotifierProvider(create: (_) => EditEventsController()),
        ChangeNotifierProvider(create: (_) => FetchController()),
        ChangeNotifierProvider(create: (_) => Register()),
        ChangeNotifierProvider(create: (_) => SeatController()),
        ChangeNotifierProvider(create: (_) => CalendarController()),
        ChangeNotifierProvider(create: (_) => LogoutController()),
        ChangeNotifierProvider(create: (_) => EventSearchController()),
        ChangeNotifierProvider(create: (_) => SpeakerSearchController()),
        ChangeNotifierProvider(create: (_) => BottomNavBarController()),
        ChangeNotifierProvider(create: (_) => StaffNavBarController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-QIU Guidance',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ResponsiveLayout(
          desktopBody: LoginDesktop(),
          mobileBody: Login(),
        ),
      ),
    );
  }
}
