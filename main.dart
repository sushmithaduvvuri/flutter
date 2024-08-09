import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String _selectedDay = 'Monday';
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedActivity = 'Wake up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Day:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedDay,
              items: <String>[
                'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Select Time:', style: TextStyle(fontSize: 16)),
            ListTile(
              title: Text('${_selectedTime.format(context)}'),
              subtitle: Text('Tap to select time'),
              onTap: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null && time != _selectedTime) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Text('Select Activity:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedActivity,
              items: <String>[
                'Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedActivity = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleNotification() async {
    final now = DateTime.now();
    final notificationTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (notificationTime.isBefore(now)) {
      notificationTime.add(Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'It\'s time for ${_selectedActivity} on ${_selectedDay}',
      notificationTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel_id',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('alaram'),
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
