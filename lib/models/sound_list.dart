import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final soundsListsProvider = Provider((ref) => SoundsLists());

final randomSoundProvider = StateNotifierProvider<SoundNotifier, String>((ref) {
  final sounds = ref.read(soundsListsProvider);
  return SoundNotifier(sounds);
});

class SoundNotifier extends StateNotifier<String> {
  final SoundsLists sounds;

  // 初期状態をランダムな音声ファイル
  SoundNotifier(this.sounds) : super(sounds.getRandomSound());

  // ランダムに音声ファイルの状態を更新・取得
  String updateAndFetchRandomSound() {
    state = sounds.getRandomSound();
    return state;
  }
}

// 音声ファイルリストを管理
class SoundsLists {
// 音声ファイルリスト
  List<String> soundLists = [
    'cat01.mp3',
    'cat02.mp3',
    'chicken01.mp3',
    'cicada01.mp3',
    'cow01.mp3',
    'crow01.mp3',
    'cuckoo01.mp3',
    'dog01.mp3',
    'dog02.mp3',
    'elephant01.mp3',
    'horse01.mp3',
    'japanese-nightingale.mp3',
    'lion02.mp3',
    'pig01.mp3',
    'sheep01.mp3',
    'wolf01.mp3',
  ];

  // ランダムに音声ファイルを取得する
  final random = Random();
  String getRandomSound() {
    return soundLists[random.nextInt(soundLists.length)];
  }

  // リストをシャッフルする
  List<String> shuffleSounds() {
    List<String> shuffledList = List.from(soundLists);
    shuffledList.shuffle();
    return shuffledList;
  }
}
