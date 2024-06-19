import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/Staff_controllers/add_events_controller.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/outlined_button.dart';
import 'package:e_qiu_guidance/Widgets/mobile_widgets/textfield.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final GlobalKey<FormState> addEventKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addEventKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddEventController>(context);
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
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Adjust opacity as needed
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Form(
                key: addEventKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      hint: "Event Title",
                      onChanged: (value) => controller.setTitle(value),
                      validator: controller.validateEventTitle,
                    ),
                    CustomTextField(
                      hint: "Event Description",
                      onChanged: (value) => controller.setDescription(value),
                      validator: controller.validateEventDescription,
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
                        value: controller.selectedEventType,
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
                    controller.validateVisibility()!,
                    CustomTextField(
                      hint: "Event Venue",
                      onChanged: (value) => controller.setVenue(value),
                      validator: controller.validateEventVenue,
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
                    const SizedBox(
                      height: 10,
                    ),
                    for (int index = 0;
                        index < controller.speakersData.length;
                        index++)
                      Column(
                        children: [
                          CustomTextField(
                            hint: controller.speakersData[index]['Speaker'],
                            onChanged: (value) {
                              controller.setSpeaker(index, value);
                            },
                            validator: controller.validateEventSpeaker,
                          ),
                          CustomTextField(
                            hint: controller.speakersData[index]['Description'],
                            onChanged: (value) {
                              controller.setSpeakerDescription(index, value);
                            },
                            validator:
                                controller.validateEventSpeakerDescription,
                            maxLength: 50,
                            maxLine: 3,
                          ),
                        ],
                      ),
                    CustomTextField(
                      hint: "Available seats",
                      keyboard: TextInputType.number,
                      onChanged: (value) =>
                          controller.setAvailableSeats(int.parse(value)),
                      validator: controller.validateAvailableSeats,
                    ),
                    CustomTextField(
                      hint: "Reserved Seats",
                      keyboard: TextInputType.number,
                      onChanged: (value) =>
                          controller.setReservedSeats(int.parse(value)),
                      validator: controller.validateReservedSeats,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Btn(
                      text: "Add Event",
                      fontsize: 18,
                      onPressed: () {
                        if (controller.selectedRadio == "") {
                          setState(() {
                            controller.isSelected = false;
                          });
                        }
                        if (addEventKey.currentState?.validate() ?? false) {
                          controller.addEvent(context);
                        }
                      },
                      isDisabled: false,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
