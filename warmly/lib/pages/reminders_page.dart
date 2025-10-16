import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class Reminder {
  String title;
  TimeOfDay? time;

  Reminder({required this.title, this.time});
}

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<Reminder> _reminders = [];

  // Cupertino-style time picker modal
  Future<TimeOfDay?> _showCupertinoTimePicker({
    required BuildContext ctx,
    TimeOfDay? initialTime,
  }) async {
    DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialTime?.hour ?? now.hour,
      initialTime?.minute ?? now.minute,
    );

    DateTime chosen = initialDateTime;

    final result = await showCupertinoModalPopup<DateTime>(
      context: ctx,
      builder: (_) {
        return Container(
          height: 260,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(ctx),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // top action bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: const Text('Done', style: TextStyle(color: Color(0xFF6A5AE0))),
                        onPressed: () => Navigator.of(ctx).pop(chosen),
                      ),
                    ],
                  ),
                ),
                // the picker
                SizedBox(
                  height: 180,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: initialDateTime,
                    use24hFormat: false,
                    onDateTimeChanged: (DateTime newDate) {
                      chosen = newDate;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null) return null;
    return TimeOfDay(hour: result.hour, minute: result.minute);
  }

  Future<void> _addReminder() async {
    final TextEditingController titleController = TextEditingController();
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Add Reminder",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setStateSB) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Reminder",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      final picked = await _showCupertinoTimePicker(
                        ctx: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setStateSB(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTime == null
                                ? "Select Time"
                                : selectedTime!.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.access_time, color: Color(0xFF6A5AE0)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _reminders.add(
                      Reminder(title: titleController.text, time: selectedTime),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _reminders.sort((a, b) {
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      return a.time!.hour.compareTo(b.time!.hour) != 0
          ? a.time!.hour.compareTo(b.time!.hour)
          : a.time!.minute.compareTo(b.time!.minute);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reminders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: _reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      reminder.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: reminder.time != null
                        ? Text('Time: ${reminder.time!.format(context)}')
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteReminder(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        backgroundColor: Color(0xFF6A5AE0),
        elevation: 6,
        child: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
