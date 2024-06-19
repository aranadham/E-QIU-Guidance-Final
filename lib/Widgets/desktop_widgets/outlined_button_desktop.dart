import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';

class OutlinedBtnDesktop extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontsize;
  const OutlinedBtnDesktop({
    super.key,
    this.fontsize,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: blue,
        ),
        fixedSize: const Size(300, 40),
        foregroundColor: Colors.black,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontsize),
      ),
    );
  }
}
