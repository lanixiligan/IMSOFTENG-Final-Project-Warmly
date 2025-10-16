import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/messages/daily_tips.dart';

class DailyTipCard extends StatelessWidget {
  final DateTime? selectedDate;

  const DailyTipCard({super.key, this.selectedDate});

  String _getSeededTip(DateTime date) {
    final seed = int.parse(DateFormat('yyyyMMdd').format(date));
    final rng = Random(seed);
    return dailyTips[rng.nextInt(dailyTips.length)];
  }

  @override
  Widget build(BuildContext context) {
    final date = selectedDate ?? DateTime.now();
    final tip = _getSeededTip(date);
    final label = DateFormat('MMMM d').format(date).toUpperCase();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color.fromARGB(255, 103, 97, 167)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF4C3CA5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 183, 175, 245).withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6A5AE0), // soft pastel background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              tip,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
