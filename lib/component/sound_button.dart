import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundButton extends StatefulWidget {
  const SoundButton({
    Key? key,
    required this.soundFilePath,
  }) : super(key: key);

  final String soundFilePath;

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  // 押した時の状態
  bool _isButtonPressed = false;
  // 時間
  Timer? _timer;
  // オーディオ
  final audioPlayer = AudioPlayer();

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

  // 音を鳴らす
  void audioPray() {
    audioPlayer.play(AssetSource('sounds/${widget.soundFilePath}'));
  }

  // リソースのクリーンアップ
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isButtonPressed = true;
          audioPray();
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
