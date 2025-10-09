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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF4E6FF), Color(0xFFF9F6FF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tip,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A5AE0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Log menstruation tapped")),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                "LOG MENSTRUATION",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
