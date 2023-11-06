// 音声一致かどうか
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 押下したボタンに応じてテキスト変更
final soundMatchingProvider =
    StateProvider<MatchingStatus>((ref) => MatchingStatus.initial);

enum MatchingStatus {
  initial, // 初期値
  correct, // 正解
  incorrect, // 不正解
  clear, // ゲームクリア
}

String matchingText(MatchingStatus status) {
  switch (status) {
    case MatchingStatus.correct:
      return '正解♪';
    case MatchingStatus.incorrect:
      return '不正解♪';
    case MatchingStatus.clear:
      return 'ゲームクリア♪';
    case MatchingStatus.initial:
    default:
      return '同じ♪を見つけよう！';
  }
}

// 押下した1つ目と2つ目のボタンを管理
final firstPressedSoundProvider = StateProvider<String?>((ref) => null);
final secondPressedSoundProvider = StateProvider<String?>((ref) => null);

// 効果音を格納
final matchedSoundsStoreProvider = StateProvider<List<String>>((ref) => []);
