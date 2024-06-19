import 'package:flutter/material.dart';

class OutlinedBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontsize;
  const OutlinedBtn({
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
          color: Color.fromARGB(255, 0, 106, 166),
        ),
        fixedSize: const Size(350, 10),
        foregroundColor: Colors.black,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontsize),
      ),
    );
  }
}
