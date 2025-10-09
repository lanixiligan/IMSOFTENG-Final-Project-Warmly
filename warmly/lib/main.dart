import 'package:flutter/material.dart';
import 'utils/routes.dart';

void main() {
  runApp(const WarmlyApp());
}

class WarmlyApp extends StatelessWidget {
  const WarmlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warmly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F8FF),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A5AE0)),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRoutes.onGenerateRoute, // 👈 replaced routes:
      initialRoute: '/home',
    );
  }
}
