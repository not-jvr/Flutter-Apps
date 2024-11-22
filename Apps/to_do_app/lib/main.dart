import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de tener el paquete 'provider' en tu pubspec.yaml
import 'package:to_do_app/config/theme/app_theme.dart';
import 'package:to_do_app/presentation/screens/home/home_screens.dart';
import 'package:to_do_app/providers/tag/provider_tag.dart'; // Importa el TagProvider

void main() {
  runApp(
    // Envuelve tu app con ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => TagProvider(), // Crea una instancia del TagProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme(
        selectedColor: 7,
        isDarkMode: true,
      ).getTheme(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
