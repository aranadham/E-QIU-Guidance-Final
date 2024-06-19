import 'package:flutter/material.dart';
import 'package:e_qiu_guidance/mycolors.dart';

class BtnDesktop extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontSize;
  final bool isDisabled;

  const BtnDesktop({
    super.key,
    this.fontSize,
    required this.text,
    required this.onPressed,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(blue),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        minimumSize: MaterialStateProperty.all(const Size(300, 40)),
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize ?? 20), // Default font size if not provided
      ),
    );
  }
}
