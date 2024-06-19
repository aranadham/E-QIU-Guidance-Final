import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String label;
  final String value;
  const CustomTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 20),
      ),
      
    );
  }
}

class CustomText extends StatelessWidget {
  final String value;
  const CustomText({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        value,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
