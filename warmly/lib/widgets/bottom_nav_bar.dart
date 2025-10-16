import 'package:flutter/material.dart';


class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/instant_relief_tools', (r) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, '/hotlines', (r) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF6A5AE0),
        borderRadius: BorderRadius.circular(24),
         boxShadow: [
          BoxShadow(
            color: Color(0xFF6A5AE0),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIcon(context, Icons.home, 0),
          _buildIcon(context, Icons.menu, 1),
          _buildIcon(context, Icons.phone, 2),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon, int index) {
    final isSelected = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 183, 175, 245).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        splashRadius: 28,
        onPressed: () => _onTap(context, index),
      ),
    );
  }
}
