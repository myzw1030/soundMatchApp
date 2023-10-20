import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_match_app/models/sound_list.dart';

// ♪ボタン：入力無効状態
final isAbsorbingProvider = StateProvider<bool>((ref) => true);

// 音声一致かどうか
final matchingProvider =
    StateProvider<MatchingStatus>((ref) => MatchingStatus.initial);

enum MatchingStatus {
  initial, // 初期値
  correct, // 正解
  incorrect, // 不正解
  waitingForAnswer, //回答待ち
}

class SoundButton extends ConsumerStatefulWidget {
  const SoundButton({
    Key? key,
    required this.isQuestionAbsorbing,
    required this.toggleAbsorbing,
    required this.soundFilePath,
  }) : super(key: key);

  final String soundFilePath;
  final bool isQuestionAbsorbing;
  final Function toggleAbsorbing;

  @override
  ConsumerState createState() => _SoundButtonState();
}

class _SoundButtonState extends ConsumerState<SoundButton> {
  // 押した時の状態
  bool isButtonPressed = false;
  bool isQuestionAbsorbing = false;

  // 時間
  Timer? timer;
  // オーディオ
  final audioPlayer = AudioPlayer();

  // 再生時間が長い場合強制的に終了させる用
  void resetAndStartTimer() {
    timer?.cancel();
    // タイマー開始
    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      setState(() {
        soundMatch();
      });
      await audioPlayer.stop();
      await audioPlayer.release();
      timer?.cancel();
    });
  }

  // 音を鳴らす
  void audioPlay() async {
    try {
      await audioPlayer.play(AssetSource('sounds/${widget.soundFilePath}'));
    } catch (e) {
      print('error: $e');
      await audioPlayer.stop();
    }
  }

  // 出題との音判定
  void soundMatch() {
    final currentRandomSound = ref.watch(randomSoundProvider);
    if (widget.soundFilePath == currentRandomSound) {
      print('一致！:${widget.soundFilePath}');
      isButtonPressed = true;
    } else {
      print('不一致..:${widget.soundFilePath}');
      isButtonPressed = false;
    }
  }

  // 押下した時のテキスト変更チェック用
  void checkMatch(String soundFilePath) {
    final currentRandomSound = ref.watch(randomSoundProvider);
    if (soundFilePath == currentRandomSound) {
      ref.read(matchingProvider.notifier).state = MatchingStatus.correct;
      resetMatchingState();
    } else {
      ref.read(matchingProvider.notifier).state = MatchingStatus.incorrect;
      resetMatchingState();
    }
  }

  // テキスト元に戻す様
  void resetMatchingState() {
    Timer(const Duration(seconds: 1), () {
      ref.read(matchingProvider.notifier).state = MatchingStatus.initial;
    });
  }

  // 初回
  @override
  void initState() {
    super.initState();
    // 再生中はボタン入力無効playing
    // audioPlayer.onPlayerStateChanged.listen((PlayerState s) => {
    //       if (s == PlayerState.playing)
    //         {
    //           setState(() {
    //             // ref.read(isAbsorbingProvider.notifier).state = true;
    //             // debugPrint(
    //             //     '再生中${ref.read(isAbsorbingProvider.notifier).state}');
    //           }),
    //         }
    //     });
    // // 再生終了後、ステータス変更
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        soundMatch();
      });
      // audioPlayer.stop();
    });
  }

  // リソースのクリーンアップ
  @override
  void dispose() async {
    await audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // absorbingの状態を取得
    final bool isAbsorbing = ref.watch(isAbsorbingProvider);

    return AbsorbPointer(
      absorbing: isAbsorbing,
      child: GestureDetector(
        onTap: () {
          isButtonPressed = true;
          // 出題ボタンの状態を変更
          widget.toggleAbsorbing();
          // ♪ボタン無効化
          ref.read(isAbsorbingProvider.notifier).state = true;
          // 効果音
          audioPlay();
          checkMatch(widget.soundFilePath);
          resetAndStartTimer();
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
