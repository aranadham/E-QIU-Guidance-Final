import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? ontap;
  const Box({
    super.key,
    required this.icon,
    required this.text,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            // color: const Color.fromARGB(255, 136, 137, 141),
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.black54,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
