import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputAction,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction inputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: const Color(0xff2A3F54),
      obscureText: obscureText,
      keyboardType: TextInputType.number,
      textInputAction: inputAction,
      controller: controller,
      onTapOutside: (value) => FocusScope.of(context).unfocus(),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1.5,
            color: Color(0xff2A3F54),
          ),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 0),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF3D3D3D),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
