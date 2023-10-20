import 'package:audioplayers/audioplayers.dart';

// // Providerを使用してAudioPlayerのインスタンスを生成
// final audioPlayerProvider = Provider<AudioPlayer>((ref) {
//   final audioPlayer = AudioPlayer();

//   // 再生が完了したらリソースを解放する
//   audioPlayer.onPlayerComplete.listen((event) async {
//     await audioPlayer.release();
//   });

//   return audioPlayer;
// });

// // 再生した時
// // 非同期、また使用時に引数を指定するため
// final playSoundProvider =
//     FutureProvider.family<void, String>((ref, soundPath) async {
//   final audioPlayer = ref.read(audioPlayerProvider);

//   // 再生時間が長い場合強制的に終了させる用
//   Timer? timer;

//   // 再生時間が長い場合強制的に終了させる用
//   void resetAndStartTimer() {
//     timer?.cancel();
//     // タイマー開始
//     timer = Timer.periodic(const Duration(seconds: 3), (_) async {
//       await audioPlayer.stop();
//       // ref.read(isAbsorbingProvider.notifier).state = false;
//       timer?.cancel();
//     });
//   }

//   // 音声の再生とエラーハンドリング
//   try {
//     if (audioPlayer.state == PlayerState.playing) {
//       await audioPlayer.stop();
//     }
//     await audioPlayer.play(AssetSource('sounds/$soundPath'));
//     resetAndStartTimer();
//   } catch (e) {
//     print("Error playing sound: $e");
//     await audioPlayer.stop();
//     await audioPlayer.release(); // エラーが発生した場合もリソースを解放
//   }
// });

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 音を鳴らす
  void audioPlay(String soundFilePath) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$soundFilePath'));
    } catch (e) {
      print('error: $e');
      await _audioPlayer.stop();
    }
  }
}
