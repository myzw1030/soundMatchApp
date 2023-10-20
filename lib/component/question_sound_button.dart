import 'package:flutter/material.dart';
import 'package:sound_match_app/component/sound_button.dart';
import 'package:sound_match_app/models/sound_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class QuestionSoundButton extends ConsumerStatefulWidget {
  const QuestionSoundButton({
    Key? key,
    required this.isQuestionAbsorbing,
    required this.toggleAbsorbing,
  }) : super(key: key);

  final bool isQuestionAbsorbing;
  final Function toggleAbsorbing;

  @override
  ConsumerState createState() => _QuestionSoundButtonState();
}

class _QuestionSoundButtonState extends ConsumerState<QuestionSoundButton> {
  // 時間
  Timer? timer;
  // オーディオ
  final audioPlayer = AudioPlayer();

  // 音を鳴らす
  void audioPlay(soundFilePath) async {
    try {
      await audioPlayer.play(AssetSource('sounds/$soundFilePath'));
    } catch (e) {
      print('error: $e');
      await audioPlayer.stop();
    }
  }

  // 再生時間が長い場合強制的に終了させる用
  void resetAndStartTimer() {
    timer?.cancel();
    // タイマー開始
    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await audioPlayer.stop();
      await audioPlayer.release();
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isQuestionAbsorbing,
      child: ElevatedButton(
        onPressed: () async {
          // 効果音をランダムに取得
          final sourcePath = ref
              .read(randomSoundProvider.notifier)
              .updateAndFetchRandomSound();
          audioPlay(sourcePath);
          resetAndStartTimer();

          // 出題ボタン無効化
          widget.toggleAbsorbing();
          // ♪ボタン押下可能へ
          ref.read(isAbsorbingProvider.notifier).state = false;
          // テキストを初期値へ
          ref.read(matchingProvider.notifier).state =
              MatchingStatus.waitingForAnswer;
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 50),
          backgroundColor: Colors.grey,
        ),
        child: const Text(
          '出題する',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
