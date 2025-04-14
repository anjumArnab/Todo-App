import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const TaskTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.completed,
    this.onTap,
    this.onDoubleTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: ListTile(
          leading: Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: Colors.deepPurple,
          ),
          title: Text(
            title,
            style: TextStyle(
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: completed ? Colors.grey : Colors.black,
            ),
          ),
          onTap: onTap,
       
      ),
    );
  }
}
