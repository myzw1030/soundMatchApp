import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  ClearButton({
    super.key,
    required this.color,
    required this.text,
    required this.onTap,
  });

  final Color color;
  final String text;
  final Function() onTap;

  // 押した時の状態
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: color,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // child: Container(
      //   width: double.infinity,
      //   padding: const EdgeInsets.all(16),
      //   decoration: BoxDecoration(
      //     color: color,
      //     borderRadius: BorderRadius.circular(4),
      //     border: Border.all(
      //         color: isButtonPressed
      //             ? Colors.grey.shade200
      //             : Colors.grey.shade300),
      //     boxShadow: isButtonPressed
      //         ? [
      //             // 押下時は影なし
      //           ]
      //         : [
      //             BoxShadow(
      //               color: Colors.grey.shade400,
      //               offset: const Offset(1, 1),
      //               blurRadius: 1,
      //               spreadRadius: 1,
      //             ),
      //             const BoxShadow(
      //               color: Colors.white,
      //               offset: Offset(-1, -1),
      //               blurRadius: 1,
      //               spreadRadius: 1,
      //             ),
      //           ],
      //   ),
    );
  }
}
