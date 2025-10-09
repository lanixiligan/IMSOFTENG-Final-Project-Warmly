import 'package:flutter/material.dart';

class BreathingPage extends StatelessWidget {
  const BreathingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB276F8),
      appBar: AppBar(
        backgroundColor: Colors.amber.shade100,
        title: const Text(
          "Breathing Exercises",
          style: TextStyle(
            color: Color(0xFF6A1B9A),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF6A1B9A)),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Follow guided breathing routines to help you relax.",
            style: TextStyle(
              color: Color(0xFF6A1B9A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
