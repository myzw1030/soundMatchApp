import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_match_app/component/clear_button.dart';
import 'package:sound_match_app/component/sound_button.dart';
import 'package:sound_match_app/models/sound_list.dart';
import 'package:sound_match_app/page/game_page.dart';

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
    } else if (matchCount >= 25 && matchCount <= 32) {
      return clearText = '頑張ろう！';
    } else {
      return clearText = '。。。笑';
    }
  }

  // クリアに応じて星の数を変更
  List<Widget> generateStars(int matchCount) {
    int starCount;

    if (matchCount <= 8) {
      starCount = 5;
    } else if (matchCount >= 9 && matchCount <= 16) {
      starCount = 4;
    } else if (matchCount >= 17 && matchCount <= 24) {
      starCount = 3;
    } else if (matchCount >= 25 && matchCount <= 32) {
      starCount = 2;
    } else {
      starCount = 1;
    }

    return List.generate(
      starCount,
      (index) => Icon(
        Icons.star,
        color: Colors.yellow.shade800,
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...generateStars(pressedCount),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Congratulations!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
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
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '回でクリア！',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
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
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ClearButton(
              color: Colors.green.shade400,
              text: 'もう一度挑戦',
              onTap: () {
                // 初期表示にリストをシャッフル
                // 状態更新
                // ref.read(buttonsListProvider.notifier).initializeGame();
                // ref.read(countProvider.notifier).resetCount();
                // モーダル閉じる
                // context.pop();
                // 元の画面へ戻る
                // context.go('/gamePage');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ClearButton(
              color: Colors.red.shade400,
              text: 'ゲームをやめる',
              onTap: () {
                ref.read(buttonsListProvider.notifier).initializeGame();
                ref.read(countProvider.notifier).resetCount();
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
