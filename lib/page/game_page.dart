import 'package:flutter/material.dart';
import 'package:sound_match_app/component/question_sound_button.dart';
import 'package:sound_match_app/component/sound_button.dart';
import 'package:sound_match_app/models/sound_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late List<Widget> buttonsList;

  // 押下したボタンに応じてテキスト変更
  String matchingText(MatchingStatus status) {
    switch (status) {
      case MatchingStatus.correct:
        return '正解！！';
      case MatchingStatus.incorrect:
        return '不正解';
      case MatchingStatus.waitingForAnswer:
        return '♪を押してね！';
      case MatchingStatus.initial:
      default:
        return '「出題する」押して！';
    }
  }

  bool isQuestionAbsorbing = false;

  // 出題ボタンの状態を変更する
  void toggleAbsorbing() {
    setState(() {
      isQuestionAbsorbing = !isQuestionAbsorbing;
    });
  }

  @override
  void initState() {
    super.initState();
    // 初期表示にリストをシャッフル
    SoundsLists soundsLists = SoundsLists();
    List<String> shuffledSounds = soundsLists.shuffleSounds();

    buttonsList = shuffledSounds.map((soundPath) {
      return SoundButton(
        soundFilePath: soundPath,
        isQuestionAbsorbing: isQuestionAbsorbing,
        toggleAbsorbing: toggleAbsorbing,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMatching = ref.watch(matchingProvider);
    return Scaffold(
      body: Container(
        color: Colors.grey.shade300,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  matchingText(isMatching),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(-1, -1),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: buttonsList,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                QuestionSoundButton(
                  isQuestionAbsorbing: isQuestionAbsorbing,
                  toggleAbsorbing: toggleAbsorbing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
