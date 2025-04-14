import 'package:dbapp/screens/add_task_screen.dart';
import 'package:dbapp/screens/calendar_view_screen.dart';
import 'package:dbapp/screens/task_details_screen.dart';
import 'package:dbapp/widgets/task_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _navToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );
  }

  void _navToCalendarScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalendarScreen(),
      ),
    );
  }

  void _navToTaskDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("My Todos"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navToAddTask(context)),
          const SizedBox(width: 10),
          IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () => _navToCalendarScreen(context)),
          const SizedBox(width: 15)
        ],
        bottom: TabBar(
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: "All todos"),
            Tab(text: "Today"),
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(4, (index) => buildTaskList(index)),
      ),
    );
  }

  Widget buildTaskList(int index) {
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

    List<Map<String, dynamic>> filtered = switch (index) {
      1 => tasks
          .where((task) => task['subtitle'].toString().contains("Today"))
          .toList(),
      2 => tasks
          .where((task) =>
              task['subtitle'].toString().contains("Apr") ||
              task['subtitle'].toString().contains("Tomorrow"))
          .toList(),
      3 => tasks.where((task) => task['completed'] == true).toList(),
      _ => tasks
    };

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final task = filtered[i];
        return TaskTile(
          title: task['title'],
          subtitle: task['subtitle'],
          completed: task['completed'],
          onTap: () {
            setState(() {
              task['completed'] = !task['completed'];
            });
          },
          onDoubleTap: () => _navToTaskDetailsScreen(context),
        );
      },
    );
  }
}
