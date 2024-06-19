import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/login_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/outlined_button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';
import 'package:e_qiu_guidance/mycolors.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    LoginController login = LoginController();
    login.autoLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        backgroundColor: blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset("assets/qiu2.png"),
            const SizedBox(
              height: 50,
            ),
            CustomTextField(
              hint: "Email",
              onChanged: (value) => controller.setEmail(value),
              onSubmitted: (value) async {
                await controller.login(context: context);
              },
              
            ),
            CustomTextField(
              hint: "Password",
              onChanged: (value) => controller.setPassword(value),
              obscureText: true,
              onSubmitted: (value) async {
                await controller.login(context: context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Btn(
              onPressed: () async {
                await controller.login(context: context);
              },
              text: "Login",
              fontsize: 20,
              isDisabled: false,
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedBtn(
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
