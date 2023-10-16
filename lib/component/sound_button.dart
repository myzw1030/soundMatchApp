import 'dart:async';

import 'package:flutter/material.dart';

class SoundButton extends StatefulWidget {
  const SoundButton({
    Key? key,
  }) : super(key: key);

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  bool _isButtonPressed = false;
  Timer? _timer;

  // TODO
  // 本来は時間ではなく、イベント後に真偽値変更する
  void startTimer() {
    // タイマー開始
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _isButtonPressed = false;
      });
      _timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isButtonPressed = true;
          startTimer();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 120,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: _isButtonPressed
                  ? Colors.grey.shade200
                  : Colors.grey.shade300),
          boxShadow: _isButtonPressed
              ? [
                  // 押下時は影なし
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    offset: const Offset(2, 2),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Icon(
          Icons.music_note,
          size: _isButtonPressed ? 43 : 45,
          color: _isButtonPressed ? Colors.grey.shade500 : Colors.black,
        ),
      ),
    );
  }
}
