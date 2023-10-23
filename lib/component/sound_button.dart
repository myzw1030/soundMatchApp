import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_match_app/models/sound_list.dart';

// ♪ボタン：入力無効状態
final isAbsorbingProvider = StateProvider<bool>((ref) => false);

// 音声一致かどうか
final matchingProvider =
    StateProvider<MatchingStatus>((ref) => MatchingStatus.initial);

final firstPressedSoundProvider = StateProvider<String?>((ref) => null);
final secondPressedSoundProvider = StateProvider<String?>((ref) => null);

// SoundButton
final firstPressedButtonProvider =
    StateProvider<_SoundButtonState?>((ref) => null);
final secondPressedButtonProvider =
    StateProvider<_SoundButtonState?>((ref) => null);

enum MatchingStatus {
  initial, // 初期値
  correct, // 正解
  incorrect, // 不正解
  waitingForAnswer, //回答待ち
}

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
  String? firstPressedSound;
  String? secondPressedSound;
  // 最初に押されたボタンの参照
  _SoundButtonState? firstPressedButton;

  // 時間
  Timer? timer;
  // オーディオ
  final audioPlayer = AudioPlayer();

  // 再生時間が長い場合強制的に終了させる用
  void resetAndStartTimer() {
    timer?.cancel();
    // タイマー開始
    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      // setState(() {
      //   soundMatch();
      // });
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

  // ボタンの状態をリセットするメソッド
  void resetButton() {
    setState(() {
      isButtonPressed = false;
    });
  }

  // 2つの音を保存するための変数
// 出題との音判定
  List<String> matchedSounds = [];
  void soundMatch() {
    final firstSound = ref.read(firstPressedSoundProvider.notifier).state;
    final secondSound = ref.read(secondPressedSoundProvider.notifier).state;

    if (firstSound == null) {
      print('1つめが押された');
      ref.read(firstPressedSoundProvider.notifier).state = widget.soundFilePath;
      // 最初にタップされたSoundButtonの状態をfirstPressedButtonProviderに保存
      ref.read(firstPressedButtonProvider.notifier).state = this;
      // 押下動作
      setState(() {
        isButtonPressed = true;
      });
    } else if (secondSound == null) {
      print('2つめが押された');
      ref.read(secondPressedSoundProvider.notifier).state =
          widget.soundFilePath;
      // 2つ目にタップされたSoundButtonの状態をsecondPressedButtonProviderに保存
      ref.read(secondPressedButtonProvider.notifier).state = this;
      // 押下動作
      setState(() {
        isButtonPressed = true;
      });

      if (firstSound == widget.soundFilePath) {
        print('一致');
        matchedSounds.add(widget.soundFilePath);
      } else {
        print('不一致');
        // 最初に押されたボタンの状態を取得し、それに対してのみリセット
        final firstButton = ref.read(firstPressedButtonProvider.notifier).state;
        firstButton?.resetButton(); // ボタンの状態をリセット
        // 2つ目リセット
        setState(() {
          isButtonPressed = false;
        });
      }

      // リセット
      ref.read(firstPressedSoundProvider.notifier).state = null;
      ref.read(secondPressedSoundProvider.notifier).state = null;
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
      // setState(() {
      //   soundMatch();
      // });
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
          // setState(() {
          //   // 押したときにボタンが沈む
          //   isButtonPressed = true;
          // });
          soundMatch();
          // print(isButtonPressed);
          // 出題ボタンの状態を変更
          // widget.toggleAbsorbing();
          // ♪ボタン無効化
          // ref.read(isAbsorbingProvider.notifier).state = true;
          // 効果音
          audioPlay();
          // checkMatch(widget.soundFilePath);
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
