import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fabula_tcg_app/core/theme/app_theme.dart';
import 'package:fabula_tcg_app/presentation/screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FabulaTcgApp(),
    ),
  );
}

class FabulaTcgApp extends StatelessWidget {
  const FabulaTcgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fábula TCG',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
