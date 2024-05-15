import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String value;
  VoidCallback pressed;

  Button({
    super.key,
    required this.value,
    required this.pressed,
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
          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
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
