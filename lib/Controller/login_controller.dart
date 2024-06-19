// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_qiu_guidance/Widgets/bottom_nav_bar_ui.dart';
import 'package:e_qiu_guidance/Widgets/staff_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  String email = '';
  String password = '';
  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  static const String isLoggedInKey = 'isLoggedIn';

  Future<void> saveLoginStatus(bool isLoggedIn, String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLoggedInKey, isLoggedIn);
    prefs.setString('userRole', role);
  }

  Future<Map<String, dynamic>> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;
    String userRole =
        prefs.getString('userRole') ?? 'NormalUser'; // Default role
    return {'isLoggedIn': isLoggedIn, 'userRole': userRole};
  }

  void autoLogin(BuildContext context) async {
    Map<String, dynamic> loginStatus = await getLoginStatus();

    if (loginStatus['isLoggedIn']) {
      if (loginStatus['userRole'] == 'Staff') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StaffNavBar(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      }
    }
  }

  //function to login using email and password
  Future<void> login({
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Logging in...",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Sign in with email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is not null
      if (user != null) {
        // Access the Firestore collection 'staff' and check the user's role
        DocumentSnapshot staffDoc = await FirebaseFirestore.instance
            .collection('Staff')
            .doc(user.uid)
            .get();
        if (staffDoc.exists) {
          String role = staffDoc['role'];
          await saveLoginStatus(true, role);

          // Check if the user's role is 'staff'
          if (role == 'Staff') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffNavBar(),
              ),
            );
            return;
          }
        }

        await saveLoginStatus(true, "Student");

        // If the user is not a staff member, navigate to the default home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      }
    } on FirebaseAuthException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid Email or Password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> signInAnonymously(BuildContext context) async {
    try {
      String role = 'Guest';
      await saveLoginStatus(true, role);
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
      );
    } catch (e) {
      debugPrint("Error signing in anonymously: $e");
    }
  }
}
