import 'package:e_qiu_guidance/Widgets/desktop_widgets/button_desktop.dart';
import 'package:e_qiu_guidance/Widgets/desktop_widgets/outlined_button_desktop.dart';
import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/edit_event_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';

class EditEventDesktop extends StatefulWidget {
  const EditEventDesktop({super.key});

  @override
  State<EditEventDesktop> createState() => _EditEventDesktopState();
}

class _EditEventDesktopState extends State<EditEventDesktop> {
  late final EditEventsController controller;
  bool controllerInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!controllerInitialized) {
      controller = Provider.of<EditEventsController>(context);

      controllerInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              initialValue: controller.title,
              hint: "Event Title",
              onChanged: (value) => controller.setTitle(value),
            ),
            CustomTextField(
              initialValue: controller.description,
              hint: "Event Description",
              onChanged: (value) => controller.setDescription(value),
              maxLine: 3,
              maxLength: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Event Type',
                  prefixIcon: const Icon(
                    Icons.event,
                    color: blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 106, 166),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 106, 166),
                    ),
                  ),
                ),
                value: controller.type,
                onChanged: (String? value) {
                  if (value != null) {
                    controller.setType(value);
                  }
                },
                validator: controller.validateEventType,
                items: controller.eventTypes.map((String eventType) {
                  return DropdownMenuItem<String>(
                    value: eventType,
                    child: Text(eventType),
                  );
                }).toList(),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: blue,
                ),
                dropdownColor: lightblue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RadioListTile(
                title: const Text('Public'),
                activeColor: const Color.fromARGB(255, 0, 174, 239),
                value: "Public",
                groupValue: controller.selectedRadio,
                onChanged: (value) {
                  controller.setSelectedRadio(value!);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RadioListTile(
                title: const Text('Private'),
                activeColor: const Color.fromARGB(255, 0, 174, 239),
                value: "Private",
                groupValue: controller.selectedRadio,
                onChanged: (value) {
                  controller.setSelectedRadio(value!);
                },
              ),
            ),
            CustomTextField(
              initialValue: controller.venue,
              hint: "Event venue",
              onChanged: (value) => controller.setVenue(value),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Event Start Date: ${controller.selectedStartDateTime}",
                style: const TextStyle(fontSize: 22),
              ),
            ),
            OutlinedBtnDesktop(
              text: "Select Time",
              onPressed: () {
                controller.pickStartTime(context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedBtnDesktop(
              text: "Select Date",
              onPressed: () {
                controller.pickStartDate(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Event End Date: ${controller.selectedEndDateTime}",
                style: const TextStyle(fontSize: 22),
              ),
            ),
            OutlinedBtnDesktop(
              text: "Select Time",
              onPressed: () {
                controller.pickEndTime(context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedBtnDesktop(
              text: "Select Date",
              onPressed: () {
                controller.pickEndDate(context);
              },
            ),
            ListTile(
              title: Text("Duration: ${controller.calculateEventDuration()}"),
            ),
            const SizedBox(
              height: 20,
            ),
            BtnDesktop(
              text: "Update",
              onPressed: () async {
                await controller.updateEvent(context);
              },
              isDisabled: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.title = "";
    controller.description = "";
    controller.type = "";
    controller.selectedRadio = "";
    controller.venue = "";
    controller.selectedStartDateTime = DateTime.now();
    controller.selectedEndDateTime = DateTime.now();
    super.dispose();
  }
}
