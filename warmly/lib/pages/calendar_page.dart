import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  final List<DateTime> _periodDays = [];

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isPeriodDay(DateTime day) {
    for (final d in _periodDays) {
      if (isSameDay(d, day)) return true;
    }
    return false;
  }

  void _togglePeriodDay(DateTime day) {
    final normalized = _normalizeDate(day);
    setState(() {
      if (_isPeriodDay(normalized)) {
        _periodDays.removeWhere((d) => isSameDay(d, normalized));
      } else {
        _periodDays.add(normalized);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),  // Light background for a softer look
      appBar: AppBar(
        title: const Text('Period Calendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
        elevation: 4,  // Added subtle elevation for a more defined AppBar
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),  // Slightly increased for better spacing
          
          // 🩸 Info Guide with enhanced styling
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(  // Added shadow for depth
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )],
              ),
              padding: const EdgeInsets.all(16),  // Increased padding for better readability
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFF6A5AE0), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'To mark your period days, long press on a date. '
                      'The date will turn red to signify it as a period day. '
                      'Long press again to unmark it.',
                      style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5, fontWeight: FontWeight.w500),  // Adjusted for better readability
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),  // Adjusted for improved vertical spacing
          
          // 🗓️ Simplified Calendar with enhanced styling
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6A5AE0)),
            ),
            calendarStyle: const CalendarStyle(
              defaultDecoration: BoxDecoration(  // Added for a subtle circle on all days
                shape: BoxShape.circle,
                color: Color(0xFFF0F0F0),  // Light gray for regular days
              ),
              todayDecoration: BoxDecoration(
                color: Color(0xFF6A5AE0),
                shape: BoxShape.circle,
              ),
            ),
            onDayLongPressed: (selectedDay, focusedDay) {
              _togglePeriodDay(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_isPeriodDay(day)) {
                  // 🔴 Red circle for period days
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return null;  // Falls back to default style
              },
              todayBuilder: (context, day, focusedDay) {
                // Highlight today (purple)
                return Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6A5AE0),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}