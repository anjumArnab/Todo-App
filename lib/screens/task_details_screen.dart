import 'package:dbapp/widgets/button.dart';
import 'package:dbapp/widgets/subtask_item.dart';
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isExpanded = false;
  
  // Subtasks with completion status
  final List<Map<String, dynamic>> subtasks = [
    {'title': 'Gather metrics', 'isCompleted': true},
    {'title': 'Draft executive summary', 'isCompleted': false},
    {'title': 'Create visuals and charts', 'isCompleted': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,

      ),
      
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Task Title
                const Text(
                  'Finish project report',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Due Date
                const Row(
                  children: [
                   Icon(Icons.access_time, size: 16, color: Colors.grey),
                   SizedBox(width: 4),
                  Text(
                      'Tomorrow, 10:00 AM',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Priority
                const Row(
                  children: [
                    Icon(Icons.flag, size: 16, color: Colors.orange),
                   SizedBox(width: 4),
                   Text(
                      'Medium Priority',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Complete the quarterly project report with all metrics',
                  style: TextStyle(fontSize: 14),
                ),
                
                const SizedBox(height: 16),
                
                // Subtasks
                const Text(
                  'Subtasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtask List
                ...subtasks.map((subtask) => _buildSubtaskItem(subtask)),
                
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        label: 'EDIT',
                        onPressed: () {
                          // Edit task logic
                        },
                      )
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        label: 'DELETE',
                        onPressed: () {
                          // Delete task logic
                        },
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtaskItem(Map<String, dynamic> subtask) {
    return SubtaskItem(subtask: subtask);
  }
}