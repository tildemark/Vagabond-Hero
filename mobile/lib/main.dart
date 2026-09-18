import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/game_theme.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: VagabondHeroApp(),
    ),
  );
}

class VagabondHeroApp extends StatelessWidget {
  const VagabondHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vagabond Hero',
      debugShowCheckedModeBanner: false,
      theme: createGameTheme(),
      home: const DashboardScreen(),
    );
  }
}
