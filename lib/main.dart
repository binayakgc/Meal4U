import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'theme.dart';

void main() {
  runApp(const Meal4UApp());
}

class Meal4UApp extends StatelessWidget {
  const Meal4UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Meal4U',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        home: const _PlaceholderHome(),
      ),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login screen goes here next')),
    );
  }
}