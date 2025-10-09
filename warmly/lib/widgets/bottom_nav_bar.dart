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
        Navigator.pushNamedAndRemoveUntil(context, '/breathing', (r) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, '/hotlines', (r) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
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
    return IconButton(
      icon: Icon(icon,
          color: isSelected ? const Color(0xFF6A5AE0) : Colors.grey.shade400),
      onPressed: () => _onTap(context, index),
    );
  }
}
