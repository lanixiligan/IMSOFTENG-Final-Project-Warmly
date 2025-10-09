import 'package:flutter/material.dart';
import '../widgets/header_card.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/affirmation_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderCard(
                onDateSelected: _onDateSelected, // ✅ connect calendar
                selectedDate: _selectedDate,
              ),
              const SizedBox(height: 20),
              DailyTipCard(selectedDate: _selectedDate), // ✅ pass date here
              const SizedBox(height: 20),
              const AffirmationCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
