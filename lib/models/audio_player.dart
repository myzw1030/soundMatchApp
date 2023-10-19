import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// final isAbsorbingProvider = StateProvider<bool>((ref) => false);

// Providerを使用してAudioPlayerのインスタンスを生成
final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final audioPlayer = AudioPlayer();

  // プロバイダが破棄される際に停止・リリース
  ref.onDispose(() {
    audioPlayer.stop();
    audioPlayer.release();
  });
  return audioPlayer;
});

// 再生した時
// 非同期、また使用時に引数を指定するため
final playSoundProvider =
    FutureProvider.family<void, String>((ref, soundPath) async {
  final audioPlayer = ref.read(audioPlayerProvider);

  // Timerはlocal
  // 再生時間が長い場合強制的に終了させる用
  Timer? localTimer;

  // 音声の再生とエラーハンドリング
  try {
    await audioPlayer.play(AssetSource('sounds/$soundPath'));
    print('再生中');
    localTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      audioPlayer.stop();
      localTimer?.cancel();
      // ref.read(isAbsorbingProvider.notifier).state = false;
      // print('timerで再生終了');
    });
    // localTimer.cancel();
  } catch (e) {
    print("Error playing sound: $e");
    audioPlayer.stop();
  }
});
