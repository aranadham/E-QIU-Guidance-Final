import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/register_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({super.key});

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final GlobalKey<FormState> registerStudentKey = GlobalKey<FormState>();

  late final Register controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!controllerInitialized) {
      controller = Provider.of<Register>(context);
      controllerInitialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.username = "";
    controller.email = "";
    controller.password = "";
  }

  bool controllerInitialized = false;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Register>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/QIU wallpaper2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
            color: Colors.grey.withOpacity(0.9),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white, // Adjust opacity as needed
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListView(
                children: [
                  Form(
                    key: registerStudentKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          hint: "Student Name",
                          validator: controller.validateUserName,
                          onChanged: (value) => controller.setUserName(value),
                        ),
                        CustomTextField(
                          hint: "Email",
                          validator: controller.validateEmail,
                          onChanged: (value) => controller.setEmail(value),
                        ),
                        CustomTextField(
                          hint: "Password",
                          validator: controller.validatePassword,
                          onChanged: (value) => controller.setPassword(value),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Btn(
                            text: "Register Student",
                            onPressed: () {
                              if (registerStudentKey.currentState?.validate() ??
                                  false) {
                                controller.registerStudent(context);
                              }
                            },
                            isDisabled: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
