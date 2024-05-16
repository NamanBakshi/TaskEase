import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String value;
  final bool isEnabled;
  VoidCallback pressed;

  Button({
    super.key,
    required this.value,
    required this.pressed,
    required this.isEnabled
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed:pressed,
        style: ButtonStyle(
         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
           RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5.0),
           ),
         ),
          backgroundColor: MaterialStateProperty.all<Color>(isEnabled ? Colors.lightBlueAccent : Colors.grey),
          // side:BorderSide(style:BorderStyle),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
