import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 入力無効状態
final isAbsorbingProvider = StateProvider<bool>((ref) => false);

class SoundButton extends ConsumerStatefulWidget {
  const SoundButton({
    Key? key,
    required this.soundFilePath,
  }) : super(key: key);

  final String soundFilePath;

  @override
  ConsumerState createState() => _SoundButtonState();
}

class _SoundButtonState extends ConsumerState<SoundButton> {
  // 押した時の状態
  bool isButtonPressed = false;
  // 時間
  Timer? timer;
  // オーディオ
  final audioPlayer = AudioPlayer();

  // 再生時間が長い場合強制的に終了させる用
  void resetAndStartTimer() {
    timer?.cancel();
    // タイマー開始
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        isButtonPressed = false;
      });
      ref.read(isAbsorbingProvider.notifier).state = false;
      audioPlayer.stop();
      timer?.cancel();
    });
  }

  // 音を鳴らす
  void audioPray() {
    audioPlayer.play(AssetSource('sounds/${widget.soundFilePath}'));

    // // 再生終了後、ステータス変更
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isButtonPressed = false;
      });
      ref.read(isAbsorbingProvider.notifier).state = false;
      audioPlayer.stop();
    });
  }

  // リソースのクリーンアップ
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Riverpodからabsorbingの状態を取得
    final bool isAbsorbing = ref.watch(isAbsorbingProvider);

    return AbsorbPointer(
      absorbing: isAbsorbing,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isButtonPressed = true;
            ref.read(isAbsorbingProvider.notifier).state = true;
            audioPray();
            resetAndStartTimer();
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
                color: isButtonPressed
                    ? Colors.grey.shade200
                    : Colors.grey.shade300),
            boxShadow: isButtonPressed
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
            size: isButtonPressed ? 43 : 45,
            color: isButtonPressed ? Colors.grey.shade500 : Colors.black,
          ),
        ),
      ),
    );
  }
}
