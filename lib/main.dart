import 'package:flutter/material.dart';
import 'screens/cricket_game_screen.dart';

void main() {
  runApp(const CricketApp());
}

class CricketApp extends StatelessWidget {
  const CricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Cricket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          centerTitle: true,
        ),
      ),
      home: const CricketGameScreen(),
    );
  }
}