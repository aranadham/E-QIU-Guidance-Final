import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';
class SearchField extends StatelessWidget {
  final String label;
  final void Function(String) onChanged;
  const SearchField({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.search,color: blue,size: 30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          isCollapsed: true,
        ),
      ),
    );
  }
}
