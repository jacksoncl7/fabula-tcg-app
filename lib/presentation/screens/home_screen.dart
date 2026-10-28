import 'package:flutter/material.dart';

/// Placeholder home screen for the Fábula TCG companion app.
///
/// Will be expanded with resource counters, territory zone,
/// and turn phase tracker in subsequent features.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fábula TCG'),
      ),
      body: const Center(
        child: Text(
          'Fábula TCG Companion',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
