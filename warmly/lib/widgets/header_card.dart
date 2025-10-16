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
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color.fromARGB(255, 83, 73, 194)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A5AE0),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile'); 
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF6A5AE0),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                "Warmly",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Slightly darker purple for contrast
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined, color: Color.fromARGB(255, 255, 255, 255)),
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
              widget.onDateSelected(selectedDay); 
            },
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              weekendStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 232, 243),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF4C3CA5),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Color(0xFF6A5AE0)),
              todayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              defaultTextStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              weekendTextStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
