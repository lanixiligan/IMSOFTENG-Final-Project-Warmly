import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB276F8), // purple background
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // App Title
                  Text(
                    "Warmly",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Circles row (like your screenshot top)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      8,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade800,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Date container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "AUGUST 18",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "LOG SYMPTOM",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Middle circular icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.favorite, color: Colors.white, size: 30),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.monitor_heart, color: Colors.white, size: 30),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.air, color: Colors.white, size: 30),
                ),
              ],
            ),

            const Spacer(),

            // Bottom navigation
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.amber.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.person, size: 35, color: Color(0xFF6A1B9A)),
                  Icon(Icons.alarm, size: 35, color: Color(0xFF6A1B9A)),
                  Icon(Icons.phone, size: 35, color: Color(0xFF6A1B9A)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
