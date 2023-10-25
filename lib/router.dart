import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_match_app/main.dart';
import 'package:sound_match_app/page/game_page.dart';

final router = GoRouter(
  // initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TopPage();
      },
      // routes: const [],
    ),
    GoRoute(
      path: '/gamePage',
      builder: (BuildContext context, GoRouterState state) {
        return const GamePage();
      },
    ),
  ],
);
