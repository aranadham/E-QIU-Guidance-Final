import 'package:e_qiu_guidance/Controller/fetch_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Attendance extends StatelessWidget {
  final String reportId;

  const Attendance({
    super.key,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: controller.fetchReservationCount(reportId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Report Names");
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            int count = snapshot.data ?? 0;
            return Text(" $count Reservations");
          },
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 106, 166),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/QIU wallpaper2.jpg"),
            fit: BoxFit.cover,
          ),
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
            child: StreamBuilder<List<String>>(
              stream: controller.generateReport(reportId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                List<String> names = snapshot.data ?? [];
                if (names.isEmpty) {
                  return const Center(
                    child: Text('No names found.'),
                  );
                }
                return ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final name = names[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(name),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
