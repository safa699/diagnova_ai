import 'package:flutter/material.dart';
import 'package:diagnova_ai/screens/splash_screen.dart';
import 'package:diagnova_ai/screens/home_screen.dart';

void main() {
  runApp(const DiagnovaApp());
}

class DiagnovaApp extends StatelessWidget {
  const DiagnovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diagnova AI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
        ),
      ),
      home: SplashScreen(
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
