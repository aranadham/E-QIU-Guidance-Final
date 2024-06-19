import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_qiu_guidance/Controller/fetch_controller.dart';

class ViewSeat extends StatelessWidget {
  final String userId;
  final String eventId;
  const ViewSeat({
    super.key,
    required this.userId,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FetchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat"),
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
          child: Stack(
            children: [
              Center(
                child: Image.asset("assets/qiu3.png"),
              ),
              Container(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display reserved seat values
                      FutureBuilder<int>(
                        future: controller.getReservedSeats(userId, eventId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            int reservedSeat = snapshot.data ?? 0;
          
                            return Column(
                              children: [
                                const Text(
                                  "Your Seat Number Is",
                                  style: TextStyle(fontSize: 20,color: white),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  reservedSeat.toString(),
                                  style: const TextStyle(fontSize: 40,color: white),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
