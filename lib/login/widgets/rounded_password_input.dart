import 'package:flutter/material.dart';
import 'package:winplan/login/widgets/input_container.dart';
import 'package:winplan/shared/constants.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint,
    required this.onChanged,
    this.error,
  }) : super(key: key);

  final String hint;
  final String? error;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        key: key,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        obscureText: true,
        style: TextStyle(color: Color.fromARGB(255, 16, 93, 119), fontSize:  16, fontWeight:  FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 9, 126, 165)),
          hintStyle: TextStyle(color: Color.fromARGB(255, 16, 93, 119)),
          labelStyle: TextStyle(color: Color.fromARGB(255, 16, 93, 119)),
          hintText: hint,
          errorText: error,
          filled: true,
          errorStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 210, 210),
            fontSize: 12,
          ),
          border: InputBorder.none,
          fillColor: Color.fromARGB(255, 161, 204, 245),
        ),
      ),
    );
  }
}
