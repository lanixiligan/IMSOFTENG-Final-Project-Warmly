import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class InstantReliefToolsPage extends StatelessWidget {
  const InstantReliefToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 232, 243),  // Soft light gray for consistency with other pages
      appBar: AppBar(
        backgroundColor: Color(0xFF6A5AE0),
        elevation: 4,  // Added subtle elevation for a more defined look
        title: const Text(
          'Instant Relief Tools',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,  // Boldened for emphasis
            fontSize: 20,  // Slightly increased for better readability
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),  // Kept as is, but ensured it's consistent
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),  // Retained, but could adjust if needed for flow
            _buildToolCard(
              context,
              'Breathing Exercise',
              Icons.air,
              '/breathing',
            ),
            const SizedBox(height: 24),  // Adjusted for improved vertical spacing
            _buildToolCard(
              context,
              'Stretching Routine',
              Icons.self_improvement,
              '/stretching',
            ),
            const SizedBox(height: 24),  // Consistent spacing between cards
            _buildToolCard(
              context,
              'Relaxation Guide',
              Icons.spa,
              '/relaxation',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),  // Increased vertical padding for a roomier feel
        decoration: BoxDecoration(
          color: Color(0xFF6A5AE0),  // Kept purple theme
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
              BoxShadow(
                color: Color(0xFF6A5AE0),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,  // Adjusted to better center content
          children: [
            Icon(icon, color: Color.fromARGB(255, 255, 255, 255), size: 32),  // Increased icon size for prominence
            const SizedBox(width: 16),  // Increased spacing between icon and text
            Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 18,  // Kept consistent, but ensured it matches overall design
              ),
            ),
          ],
        ),
      ),
    );
  }
}