import 'package:flutter/material.dart';

class SubtaskItem extends StatelessWidget {
  final Map<String, dynamic> subtask;
  
  const SubtaskItem({super.key, required this.subtask});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: subtask['isCompleted'] ? Colors.grey.shade200 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: subtask['isCompleted'] ? Colors.purple : Colors.white,
              border: Border.all(
                color: subtask['isCompleted'] ? Colors.purple : Colors.grey,
                width: 2,
              ),
            ),
            child: subtask['isCompleted']
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(  // Add this Expanded widget to handle text overflow
            child: Text(
              subtask['title'],
              style: TextStyle(
                decoration: subtask['isCompleted'] ? TextDecoration.lineThrough : null,
                color: subtask['isCompleted'] ? Colors.grey : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,  // Add ellipsis for text overflow
              maxLines: 2,  // Allow up to 2 lines
            ),
          ),
        ],
      ),
    );
  }
}