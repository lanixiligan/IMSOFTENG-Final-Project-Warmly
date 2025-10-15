import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class InstantReliefToolsPage extends StatelessWidget {
  const InstantReliefToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instant Relief Tools"),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToolButton(
              context,
              "Breathing Exercise",
              Icons.air,
              '/breathing',
            ),
            const SizedBox(height: 20),
            _buildToolButton(
              context,
              "Stretching Routine",
              Icons.self_improvement,
              '/stretching',
            ),
            const SizedBox(height: 20),
            _buildToolButton(
              context,
              "Relaxation Guide",
              Icons.spa,
              '/relaxation',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildToolButton(
      BuildContext context, String title, IconData icon, String route) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A5AE0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

