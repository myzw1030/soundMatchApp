import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providerを使用してAudioPlayerのインスタンスを生成
final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

// 非同期、また使用時に引数を指定するため
final playSoundProvider =
    FutureProvider.family<void, String>((ref, soundPath) async {
  final audioPlayer = ref.read(audioPlayerProvider);
  await audioPlayer.play(AssetSource('sounds/$soundPath'));
});
