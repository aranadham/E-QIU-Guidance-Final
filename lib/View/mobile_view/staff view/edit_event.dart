import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/edit_event_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/outlined_button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({super.key});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/QIU wallpaper2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.9),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Adjust opacity as needed
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
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
                  const ListTile(
                    title: Text("Event Start Date:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "${controller.selectedStartDateTime}",
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  OutlinedBtn(
                    text: "Select Time",
                    onPressed: () {
                      controller.pickStartTime(context);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedBtn(
                    text: "Select Date",
                    onPressed: () {
                      controller.pickStartDate(context);
                    },
                  ),
                  const ListTile(
                    title: Text("Event End Date:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "${controller.selectedEndDateTime}",
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  OutlinedBtn(
                    text: "Select Time",
                    onPressed: () {
                      controller.pickEndTime(context);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedBtn(
                    text: "Select Date",
                    onPressed: () {
                      controller.pickEndDate(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                        "Duration: ${controller.calculateEventDuration()}"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text(
                        "Number of Speaker: ${controller.speakersData.length}"),
                    trailing: Column(
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              controller.incrementNumberOfFields();
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              controller.decrementNumberOfFields();
                            },
                            icon: const Icon(Icons.remove),
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (int index = 0;
                      index < controller.speakersData.length;
                      index++)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CustomTextField(
                                    initialValue: controller.speakersData[index]
                                        ['Speaker'],
                                    hint: "Speaker",
                                    onChanged: (value) {
                                      controller.setSpeaker(index, value);
                                    },
                                    validator: controller.validateEventSpeaker,
                                  ),
                                  CustomTextField(
                                    initialValue: controller.speakersData[index]
                                        ['Description'],
                                    hint: "Speaker Description",
                                    onChanged: (value) {
                                      controller.setSpeakerDescription(
                                          index, value);
                                    },
                                    validator: controller
                                        .validateEventSpeakerDescription,
                                    maxLength: 50,
                                    maxLine: 3,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                // Confirm before deletion
                                bool confirmDeletion = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Deletion"),
                                      content: const Text(
                                          "Are you sure you want to delete this speaker?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDeletion) {
                                  // Call the controller function to remove the speaker
                                  await controller.removeSpeakerFromFirebase(
                                      index,
                                      controller.speakersData[index]['id']);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  Btn(
                    text: "Update",
                    onPressed: () async {
                      await controller.updateEvent(context);
                    },
                    isDisabled: false,
                  ),
                ],
              ),
            ),
          ),
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
