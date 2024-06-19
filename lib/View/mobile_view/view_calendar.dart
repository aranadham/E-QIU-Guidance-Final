import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/calendar_controller.dart';
import 'package:e_qiu_guidance/View/mobile_view/view_event.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewCalendar extends StatefulWidget {
  const ViewCalendar({super.key});

  @override
  State<ViewCalendar> createState() => _ViewCalendarState();
}

class _ViewCalendarState extends State<ViewCalendar> {
  @override
  void initState() {
    super.initState();
    final calendarController =
        Provider.of<CalendarController>(context, listen: false);
    calendarController.events = LinkedHashMap(
      equals: isSameDay,
      hashCode: calendarController.getHashCode,
    );
    calendarController.loadFirestoreEvents();
  }

  @override
  Widget build(BuildContext context) {
    final calendarController = Provider.of<CalendarController>(context);
    return Scaffold(
      body: ListView(
        children: [
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            focusedDay: calendarController.today,
            firstDay: DateTime(2024),
            lastDay: DateTime(2030),
            eventLoader: calendarController.getEventsForTheDay,
            calendarStyle: const CalendarStyle(
              markerSize: 7,
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 106, 166),
                  shape: BoxShape.circle),
              markerDecoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 174, 239),
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) =>
                isSameDay(day, calendarController.today),
            onDaySelected: calendarController.daySelected,
          ),
          ...calendarController
              .getEventsForTheDay(calendarController.today)
              .map(
                (event) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewEvents(id: event.id),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      event.title,
                    ),
                    subtitle: Text("${event.description}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewEvents(id: event.id),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
