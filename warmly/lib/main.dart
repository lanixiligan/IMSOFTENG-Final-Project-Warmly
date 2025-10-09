import 'package:flutter/material.dart';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';
import 'package:warmly/daily_tips.dart';
import 'instant_relief_tools/breathing_page.dart';
import 'instant_relief_tools/stretching_page.dart';
import 'instant_relief_tools/relaxation_page.dart';
import 'package:intl/intl.dart';
import 'affirmations.dart';

void main() {
  runApp(const WarmlyApp());
}

class WarmlyApp extends StatelessWidget {
  const WarmlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warmly',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

// 
String getTodayAffirmation() {
  final now = DateTime.now();
  final seed = int.parse(DateFormat('yyyyMMdd').format(now));
  final random = Random(seed);
  final index = random.nextInt(affirmations.length);
  return affirmations[index];
}

 String getTodayDailyTip() {
  final now = DateTime.now();
  final seed = int.parse(DateFormat('yyyyMMdd').format(now));
  final random = Random(seed);
  final index = random.nextInt(affirmations.length);
  return dailyTips[index];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== HEADER CARD WITH CALENDAR =====
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
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
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFF6A5AE0),
                          child: Text(
                            "T",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Text(
                          "Warmly",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month_outlined),
                          color: Colors.grey.shade700,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // REAL CALENDAR
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Color(0xFF6A5AE0)),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Color(0xFF6A5AE0)),
                        titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF6A5AE0).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Color(0xFF6A5AE0),
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle:
                            const TextStyle(color: Colors.white),
                        weekendTextStyle:
                            const TextStyle(color: Colors.black87),
                        defaultTextStyle:
                            const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== MAIN CARD =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
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
                    Text(
                      _selectedDay != null
                          ? "${_selectedDay!.month}/${_selectedDay!.day}/${_selectedDay!.year}"
                          : "Select a date",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4E6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '"${getTodayDailyTip()}"',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5AE0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "LOG MENSTRUATION",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== AFFIRMATION CARD =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEDEAFF), Color(0xFFF9F6FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "TODAY'S AFFIRMATION",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${getTodayAffirmation()}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ===== BOTTOM NAVIGATION BAR =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(
              icon: Icons.home,
              isSelected: true,
              onTap: () {}, // Do nothing — already home
            ),
            _navButton(
              icon: Icons.monitor_heart,
              isSelected: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StretchingPage()),
                );
              },
            ),
            _navButton(
              icon: Icons.favorite,
              isSelected: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BreathingPage()),
                );
              },
            ),
            _navButton(
              icon: Icons.air,
              isSelected: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RelaxationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper for bottom navigation buttons
  Widget _navButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6A5AE0) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
