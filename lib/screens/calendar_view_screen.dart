import 'package:dbapp/screens/add_task_screen.dart';
import 'package:dbapp/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Buy groceries',
      'subtitle': 'Today, 3:00 PM',
      'completed': false,
    },
    {
      'title': 'Finish project report',
      'subtitle': 'Tomorrow, 10:00 AM',
      'completed': false,
    },
    {
      'title': 'Call dentist',
      'subtitle': 'Completed',
      'completed': true,
    },
    {
      'title': 'Team meeting',
      'subtitle': 'Apr 15, 2:00 PM',
      'completed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _navToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);

    return tasks.where((task) {
      final subtitle = task['subtitle'].toString().toLowerCase();
      DateTime? taskDate;

      if (subtitle == 'completed') return false;

      try {
        if (subtitle.startsWith('today')) {
          taskDate = DateTime.now();
        } else if (subtitle.startsWith('tomorrow')) {
          taskDate = DateTime.now().add(const Duration(days: 1));
        } else {
          final datePart = subtitle.split(',')[0]; // e.g., "Apr 15"
          final parsed = DateFormat('MMM d').parseStrict(datePart);
          taskDate = DateTime(DateTime.now().year, parsed.month, parsed.day);
        }

        return DateTime(taskDate.year, taskDate.month, taskDate.day) ==
            normalizedDay;
      } catch (_) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTasks = _getEventsForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navToAddTask(context),
          ),
          
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, // Task 01: Remove the red colored box ("2 weeks")
              titleCentered: true, // Task 02: Center the month and year name
            ),
          ),
          const Divider(thickness: 1), // Task 03: Add a divider below the calendar
          const SizedBox(height: 10),
          Expanded(
            child: selectedTasks.isEmpty
                ? const Center(child: Text('No tasks for this day'))
                : ListView.builder(
                    itemCount: selectedTasks.length,
                    itemBuilder: (context, index) {
                      final task = selectedTasks[index];
                      return TaskTile(
                        title: task['title'],
                        subtitle: task['subtitle'],
                        completed: task['completed'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}