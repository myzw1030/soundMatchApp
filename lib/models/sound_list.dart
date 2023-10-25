import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_match_app/component/sound_button.dart';

final soundsListsProvider = Provider((ref) => SoundsLists());

// 1. StateNotifierを使用して状態を管理するクラスを作成
class ButtonsListNotifier extends StateNotifier<List<Widget>> {
  ButtonsListNotifier() : super([]);

  // ゲームの初期化
  // 初期表示にリストをシャッフル
  void initializeGame() {
    SoundsLists soundsLists = SoundsLists();
    List<String> shuffledSounds = soundsLists.shuffleSounds();
    state = shuffledSounds.map((soundPath) {
      return SoundButton(
        soundFilePath: soundPath,
      );
    }).toList();
  }
}

class CountNotifier extends StateNotifier<int> {
  CountNotifier() : super(0);

  // カウント
  void increment() {
    state++;
  }

  // リセット
  void resetCount() {
    state = 0;
  }
}

// 2. StateNotifierProviderを使用して、そのクラスのインスタンスを提供
final buttonsListProvider =
    StateNotifierProvider<ButtonsListNotifier, List<Widget>>((ref) {
  return ButtonsListNotifier();
});

final countProvider = StateNotifierProvider<CountNotifier, int>((ref) {
  return CountNotifier();
});

// 音声ファイルリストを管理
class SoundsLists {
// 音声ファイルリスト
  List<String> soundLists = [
    'cat01.mp3',
    // 'cat02.mp3',
    // 'chicken01.mp3',
    // 'cicada01.mp3',
    'cow01.mp3',
    'crow01.mp3',
    // 'cuckoo01.mp3',
    'dog01.mp3',
    // 'dog02.mp3',
    'elephant01.mp3',
    'horse01.mp3',
    // 'japanese-nightingale.mp3',
    // 'lion02.mp3',
    // 'pig01.mp3',
    'sheep01.mp3',
    'wolf01.mp3',
  ];

  // ランダムに音声ファイルを取得する
  final random = Random();
  // String getRandomSound() {
  //   return soundLists[random.nextInt(soundLists.length)];
  // }

  // リストをシャッフルする
  List<String> shuffleSounds() {
    List<String> doubleList = [];
    for (var sound in soundLists) {
      doubleList.add(sound);
      doubleList.add(sound);
    }
    doubleList.shuffle();
    return doubleList;
  }
}
