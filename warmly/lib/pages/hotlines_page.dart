import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class HotlinesPage extends StatelessWidget {
  const HotlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 232, 243),
      appBar: AppBar(
        backgroundColor: Color(0xFF6A5AE0),
        elevation: 4,  
        title: const Text(
          'Emergency Hotlines',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,  
            fontSize: 20,  
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                color: Color(0xFF6A5AE0),
                shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFF6A5AE0),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text(
                  "Feature Coming Soon!\n\nEmergency Hotlines will be available here shortly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
