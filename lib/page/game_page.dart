import 'package:flutter/material.dart';
import 'package:sound_match_app/component/sound_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Widget> buttonsList = [
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'cat_meow_1.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
    const SoundButton(soundFilePath: 'wolf_howl.mp3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade300,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '正解！！！',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
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
                      crossAxisCount: 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: buttonsList,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    print('aa');
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
