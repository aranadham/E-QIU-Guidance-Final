import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final String? initialValue;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLine;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    this.hint,
    this.label,
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.keyboard,
    this.controller,
    this.validator,
    this.maxLength,
    this.maxLine,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextFormField(
        maxLines: maxLine ?? 1,
        maxLength: maxLength,
        initialValue: initialValue,
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        keyboardType: keyboard ?? TextInputType.text,
        obscureText: obscureText ?? false,
        cursorColor: const Color.fromARGB(255, 0, 174, 239),
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 106, 166),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 106, 166),
            ),
          ),
        ),
      ),
    );
  }
}
