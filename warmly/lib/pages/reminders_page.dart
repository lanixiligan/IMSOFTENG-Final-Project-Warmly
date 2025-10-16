import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../widgets/bottom_nav_bar.dart';

class Reminder {
  String title;
  TimeOfDay? time;
  bool done;

  Reminder({required this.title, this.time, this.done = false});
}

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<Reminder> _reminders = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Initialize timezone package
    tz.initializeTimeZones();
  }

  Future<void> _scheduleNotification(Reminder reminder, int id) async {
    if (reminder.time == null) return;

    final now = DateTime.now();
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      reminder.time!.hour,
      reminder.time!.minute,
    );

    // If scheduled time already passed today, schedule for next day
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(scheduled, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Reminder',
      reminder.title,
      scheduledTZ,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // daily repeat
    );
  }

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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: const Text('Done',
                            style: TextStyle(color: Color(0xFF6A5AE0))),
                        onPressed: () => Navigator.of(ctx).pop(chosen),
                      ),
                    ],
                  ),
                ),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
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
                          const Icon(Icons.access_time,
                              color: Color(0xFF6A5AE0)),
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
                    final reminder = Reminder(
                        title: titleController.text, time: selectedTime);
                    _reminders.add(reminder);

                    // Schedule daily notification
                    _scheduleNotification(reminder, _reminders.length);
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
                return GestureDetector(
                  onLongPress: () => _deleteReminder(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: Checkbox(
                        value: reminder.done,
                        activeColor: const Color(0xFF6A5AE0),
                        onChanged: (value) {
                          setState(() {
                            reminder.done = value ?? false;
                          });
                        },
                      ),
                      title: Text(
                        reminder.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: reminder.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: reminder.time != null
                          ? Text(
                              'Time: ${reminder.time!.format(context)}',
                              style: TextStyle(
                                decoration: reminder.done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        backgroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add, color: Color(0xFF6A5AE0)),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
