import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
