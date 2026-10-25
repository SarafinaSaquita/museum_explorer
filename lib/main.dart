import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const MuseumExplorerApp());

class MuseumExplorerApp extends StatelessWidget {
  const MuseumExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Museum Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1613),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE0B25C),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1613),
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
