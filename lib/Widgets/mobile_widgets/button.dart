import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/mycolors.dart';

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontsize;
  final bool isDisabled;
  const Btn({
    super.key,
    this.fontsize,
    required this.text,
    required this.onPressed,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(350, 10),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontsize),
      ),
    );
  }
}
