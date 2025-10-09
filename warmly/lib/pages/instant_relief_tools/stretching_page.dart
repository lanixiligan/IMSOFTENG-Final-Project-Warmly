import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class StretchingPage extends StatelessWidget {
  const StretchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stretching Routine"), backgroundColor: const Color(0xFF6A5AE0)),
      body: const Center(child: Text("Simple stretching routines here", style: TextStyle(fontSize: 18))),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
