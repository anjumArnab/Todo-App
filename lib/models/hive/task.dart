import 'package:hive/hive.dart';
import 'subtask.dart';

part 'task.g.dart'; // Run build_runner to generate the adapter

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String? description;
  
  @HiveField(3)
  String dueDate;
  
  @HiveField(4)
  String dueTime;
  
  @HiveField(5)
  String priority;
  
  @HiveField(6)
  List<SubTask> subTasks;
  
  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
    this.subTasks = const [],
  });
}