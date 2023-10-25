import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_match_app/component/sound_button.dart';
import 'package:sound_match_app/models/sound_list.dart';

class ClearDialog extends ConsumerStatefulWidget {
  const ClearDialog({super.key});

  @override
  ConsumerState createState() => _ClearDialogState();
}

class _ClearDialogState extends ConsumerState<ClearDialog> {
  late List<Widget> buttonsList;
  // クリアまでの回数でテキスト変更
  String clearText = '素晴らしい！';

  String matchedClearText(int matchCount) {
    if (matchCount <= 8) {
      return clearText = '神の領域です！';
    } else if (matchCount >= 9 && matchCount <= 16) {
      return clearText = '素晴らしい！';
    } else if (matchCount >= 17 && matchCount <= 24) {
      return clearText = 'まだまだですね！';
    } else {
      return clearText = '頑張ろう！';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pressedCount = ref.watch(countProvider);
    matchedClearText(pressedCount);
    return Dialog(
      shape: Border.all(
        width: 4,
        color: Colors.yellow.shade700,
      ),
      backgroundColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: Colors.yellow.shade800,
            ),
            const SizedBox(height: 20),
            const Text(
              'おめでとうございます♪',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$pressedCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '回でクリア！',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              clearText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade600,
                  ),
                ),
                child: const Text(
                  'もう一度挑戦',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              onTap: () {
                // 初期表示にリストをシャッフル
                SoundsLists soundsLists = SoundsLists();
                List<String> shuffledSounds = soundsLists.shuffleSounds();
                setState(() {
                  buttonsList = shuffledSounds.map((soundPath) {
                    return SoundButton(
                      soundFilePath: soundPath,
                    );
                  }).toList();
                });
                ref.watch(countProvider.notifier).state = 0;
                // 元の画面へ戻る（モーダル閉じる）
                context.pop();
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade600,
                  ),
                ),
                child: const Text(
                  'ゲームをやめる',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              // ホーム画面へ
              onTap: () => context.go('/'),
            )
          ],
        ),
      ),
    );
  }
}
