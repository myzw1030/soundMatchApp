import 'package:flutter/material.dart';
import 'package:sound_match_app/models/audio_player.dart';
import 'package:sound_match_app/models/sound_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionSoundButton extends ConsumerWidget {
  const QuestionSoundButton({
    Key? key,
  }) : super(key: key);

  // 音を鳴らす
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final sourcePath =
            ref.read(randomSoundProvider.notifier).updateAndFetchRandomSound();
        print(sourcePath);
        ref.read(playSoundProvider(sourcePath));
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
    );
  }
}