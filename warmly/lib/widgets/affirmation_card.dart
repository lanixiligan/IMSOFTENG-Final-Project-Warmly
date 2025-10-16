import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/messages/affirmations.dart';

class AffirmationCard extends StatelessWidget {
  const AffirmationCard({super.key});

  String _getSeededAffirmation() {
    final now = DateTime.now();
    final seed = int.parse(DateFormat('yyyyMMdd').format(now));
    final rng = Random(seed);
    return affirmations[rng.nextInt(affirmations.length)];
  }

  @override
  Widget build(BuildContext context) {
    final affirmation = _getSeededAffirmation();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6A5AE0), Color.fromARGB(255, 123, 110, 224)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A5AE0),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text("TODAY'S AFFIRMATION", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255), letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text('"$affirmation"', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 255, 255, 255))),
        ],
      ),
    );
  }
}
