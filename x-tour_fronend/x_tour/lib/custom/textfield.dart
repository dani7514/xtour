import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final double borderRadius;
  final double width;
  final double height;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  CustomTextField({
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    this.onChanged,
    required this.borderRadius,
    this.width = double.infinity,
    this.controller,
    this.validator,
    this.height = double.infinity
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}



















