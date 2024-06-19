// ignore_for_file: use_build_context_synchronously

import 'package:e_qiu_guidance/View/desktop_view/login_desktop.dart';
import 'package:e_qiu_guidance/responsive/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/Controller/login_controller.dart';
import 'package:e_qiu_guidance/View/mobile_view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends ChangeNotifier {
  void logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoginController.isLoggedInKey, false);
    prefs.remove('userRole');
    try {
      FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileBody: Login(),
            desktopBody: LoginDesktop(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Failed"),
            content: Text("Unable To logout $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }
}
