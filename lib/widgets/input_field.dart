import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String>? stream;
  final Function(String)? onChanged;

  const InputField(
      {required this.icon, required this.hint, required this.obscure, this.stream, this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: (InputDecoration(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.pinkAccent,
              ),
            ),
            contentPadding: const EdgeInsets.only(
              left: 5,
              right: 30,
              bottom: 30,
              top: 30
            ),
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
          )),
          style: const TextStyle(
            color: Colors.white,
          ),
          obscureText: obscure,
        );
      }
    );
  }
}
