import 'package:e_qiu_guidance/Widgets/desktop_widgets/button_desktop.dart';
import 'package:e_qiu_guidance/Widgets/desktop_widgets/outlined_button_desktop.dart';
import 'package:e_qiu_guidance/Widgets/desktop_widgets/textfield_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/login_controller.dart';

class LoginDesktop extends StatefulWidget {
  const LoginDesktop({super.key});

  @override
  State<LoginDesktop> createState() => _LoginDesktopState();
}

class _LoginDesktopState extends State<LoginDesktop> {
  @override
  void initState() {
    LoginController login = LoginController();
    login.autoLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Image.asset("assets/qiu2.png"),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 170),
              child: CustomTextFieldDesktop(
                hint: "Email",
                onChanged: (value) => controller.setEmail(value),
                onSubmitted: (value) async {
                  await controller.login(context: context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 170),
              child: CustomTextFieldDesktop(
                hint: "Password",
                onChanged: (value) => controller.setPassword(value),
                obscureText: true,
                onSubmitted: (value) async {
                  await controller.login(context: context);
                },
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            BtnDesktop(
              onPressed: () async {
                await controller.login(context: context);
              },
              text: "Login",
              fontSize: 20,
              isDisabled: false,
            ),
            SizedBox(
              height: screenHeight * 0.020,
            ),
            OutlinedBtnDesktop(
              text: "Guest",
              fontsize: 20,
              onPressed: () async {
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
                              "Loading...",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                await controller.signInAnonymously(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
