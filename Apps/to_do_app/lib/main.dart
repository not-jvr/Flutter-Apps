import 'package:flutter/material.dart';
import 'package:to_do_app/config/theme/app_theme.dart';
import 'package:to_do_app/presentation/screens/home/home_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme(
        selectedColor: 4,
        isDarkMode: true,
      ).getTheme(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
