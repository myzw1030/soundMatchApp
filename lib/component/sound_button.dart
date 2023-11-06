import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_match_app/component/clear_dialog.dart';
import 'package:sound_match_app/models/sound_control.dart';
import 'package:sound_match_app/models/sound_list.dart';
import 'package:collection/collection.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

// SoundButton
/* TODO 別ディレクトリに分ける */
final firstButtonStateProvider =
    StateProvider<_SoundButtonState?>((ref) => null);
final secondButtonStateProvider =
    StateProvider<_SoundButtonState?>((ref) => null);

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
  // 無効化状態
  bool isAbsorbing = false;

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
    timer = Timer(const Duration(seconds: 2), () async {
      await audioPlayer.stop();
      await audioPlayer.release();
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

  // ボタンの状態をリセット
  void resetButton() {
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isButtonPressed = false;
      });
    });
  }

  // ♪ボタン無効化用
  void changeAbsorbing() {
    setState(() {
      isAbsorbing = true;
    });
  }

  // 出題との音判定
  void soundMatch() {
    final firstSound = ref.read(firstPressedSoundProvider.notifier).state;
    final secondSound = ref.read(secondPressedSoundProvider.notifier).state;

    if (firstSound == null) {
      // print('1つめが押された');
      ref.read(firstPressedSoundProvider.notifier).state = widget.soundFilePath;
      // 最初にタップされたSoundButtonの状態をfirstPressedButtonProviderに保存
      ref.read(firstButtonStateProvider.notifier).state = this;
      // 押下動作
      setState(() {
        isButtonPressed = true;
      });
    } else if (secondSound == null) {
      // print('2つめが押された');
      ref.read(secondPressedSoundProvider.notifier).state =
          widget.soundFilePath;
      // 2つ目にタップされたSoundButtonの状態をsecondPressedButtonProviderに保存
      ref.read(secondButtonStateProvider.notifier).state = this;
      // 押下動作
      setState(() {
        isButtonPressed = true;
      });

      // ひとつめ・ふたつめに押されたボタンの状態を取得
      final firstButton = ref.read(firstButtonStateProvider.notifier).state;
      final secondButton = ref.read(secondButtonStateProvider.notifier).state;

      if (firstSound == widget.soundFilePath) {
        // print('一致');
        // 「正解」のテキスト用
        ref.read(soundMatchingProvider.notifier).state = MatchingStatus.correct;
        // ♪ボタン無効化
        firstButton?.changeAbsorbing();
        secondButton?.changeAbsorbing();

        // 一致した効果音は配列へ格納
        final currentMatchedSounds =
            ref.read(matchedSoundsStoreProvider.notifier).state;
        currentMatchedSounds.add(widget.soundFilePath);
        ref.read(matchedSoundsStoreProvider.notifier).state =
            currentMatchedSounds;

        // 格納された配列と元々のsoundsListsを比較
        final soundsLists = ref.read(soundsListsProvider).soundLists;
        final deepEq = const DeepCollectionEquality.unordered().equals;
        // print('currentMatchedSounds:$currentMatchedSounds');
        // print(deepEq(currentMatchedSounds, soundsLists));
        if (deepEq(currentMatchedSounds, soundsLists)) {
          // print('全てクリア');
          ref.read(soundMatchingProvider.notifier).state = MatchingStatus.clear;
          // timer?.cancel();

          // クリアしたらモーダル表示
          showAnimatedDialog(
            context: context,
            builder: (_) {
              return WillPopScope(
                child: const ClearDialog(),
                onWillPop: () async => false,
              );
            },
            animationType: DialogTransitionType.scale,
            duration: const Duration(
              milliseconds: 500,
            ),
          );
        } else {
          // 時間差でテキストを初期に戻す
          Timer(const Duration(seconds: 1), () {
            ref.read(soundMatchingProvider.notifier).state =
                MatchingStatus.initial;
          });
        }
      } else {
        // print('不一致');
        // 「不正解」のテキスト用
        ref.read(soundMatchingProvider.notifier).state =
            MatchingStatus.incorrect;

        // ボタンの状態をリセット
        firstButton?.resetButton();
        secondButton?.resetButton();
        // 時間差でテキストを初期に戻す
        Timer(const Duration(seconds: 1), () {
          ref.read(soundMatchingProvider.notifier).state =
              MatchingStatus.initial;
        });
      }

      // チャレンジ回数をカウント
      ref.read(countProvider.notifier).increment();

      // リセット
      ref.read(firstPressedSoundProvider.notifier).state = null;
      ref.read(secondPressedSoundProvider.notifier).state = null;
    }
  }

  // 初回
  // @override
  // void initState() {
  //   super.initState();
  // }

  // リソースのクリーンアップ
  @override
  void dispose() async {
    super.dispose();
    await audioPlayer.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAbsorbing,
      child: GestureDetector(
        onTap: () {
          soundMatch();
          // 効果音
          audioPlay();
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
