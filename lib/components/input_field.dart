import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

  late String inputName;
  late String labelText;
  late TextEditingController controller;

  CustomTextField({super.key, required this.inputName, required this.controller, required this.labelText});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
      ),
      onChanged: (newValue) {
        setState(() {
          //_password = newValue;
          widget.inputName = newValue;
        });
      },
      controller: widget.controller,
    );
  }
}
