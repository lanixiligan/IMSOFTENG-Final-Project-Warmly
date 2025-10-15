import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class RelaxationPage extends StatelessWidget {
  const RelaxationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relaxation Sounds"), backgroundColor: const Color(0xFF6A5AE0)),
      body: const Center(child: Text("Relaxation audios and sounds here", style: TextStyle(fontSize: 18))),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
