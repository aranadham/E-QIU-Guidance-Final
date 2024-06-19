import 'package:e_qiu_guidance/mycolors.dart';
import 'package:flutter/material.dart';

class CustomTextFieldDesktop extends StatelessWidget {
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

  const CustomTextFieldDesktop({
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
      padding: const EdgeInsets.symmetric(horizontal:320, vertical: 10),
      child: TextFormField(
        maxLines: maxLine ?? 1,
        maxLength: maxLength,
        initialValue: initialValue,
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        keyboardType: keyboard ?? TextInputType.text,
        obscureText: obscureText ?? false,
        cursorColor: lightblue,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: blue,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: blue,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        ),
      ),
    );
  }
}
