import 'package:flutter/material.dart';
import 'package:winplan/login/widgets/input_container.dart';
import 'package:winplan/shared/constants.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
    this.label,
    this.error,
    required this.onChanged,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final String? label;
  final String? error;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        key: key,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        style: TextStyle(
            color: Color.fromARGB(255, 16, 93, 119),
            fontSize: 16,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 9, 126, 165)),
          hintStyle: TextStyle(color: Color.fromARGB(255, 16, 93, 119)),
          labelStyle: TextStyle(color: Color.fromARGB(255, 16, 93, 119)),
          hintText: hint,
          labelText: label,
          errorText: error,
          errorStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 210, 210),
            fontSize: 12,
          ),
          filled: true,
          border: InputBorder.none,
          fillColor: Color.fromARGB(255, 161, 204, 245),
        ),
      ),
    );
  }
}
