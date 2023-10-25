import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_match_app/component/next_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_match_app/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'オトマッチェ',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    NextButton(
                      onPressed: () => context.go('/gamePage'),
                      text: 'ゲームをはじめる',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
