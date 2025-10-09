import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HeaderCard extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HeaderCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF6A5AE0),
                child: Text("T", style: TextStyle(color: Colors.white)),
              ),
              const Text(
                "Warmly",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar');
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(widget.selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              widget.onDateSelected(selectedDay); // ✅ notify parent
            },
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black54),
              weekendStyle: TextStyle(color: Colors.black54),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF6A5AE0),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF6A5AE0).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
