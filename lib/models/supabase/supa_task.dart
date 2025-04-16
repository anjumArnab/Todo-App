// task_model.dart
import 'package:dbapp/models/hive/task.dart';
import 'package:dbapp/models/supabase/supa_subtask.dart';

class TaskModel {
  final int? id;
  final String title;
  final String? description;
  final String dueDate;
  final String dueTime;
  final String priority;
  final List<SubTaskModel> subTasks;
  
  TaskModel({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
    this.subTasks = const [],
  });
  
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    List<SubTaskModel> subTasksList = [];
    
    if (json['sub_tasks'] != null) {
      if (json['sub_tasks'] is List) {
        subTasksList = (json['sub_tasks'] as List)
            .map((subTask) => SubTaskModel.fromJson(subTask))
            .toList();
      }
    }
    
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'],
      dueTime: json['due_time'],
      priority: json['priority'],
      subTasks: subTasksList,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'due_time': dueTime,
      'priority': priority,
    };
  }
  
  // Convert from Hive model
  factory TaskModel.fromHiveModel(Task hiveTask) {
    return TaskModel(
      id: hiveTask.id,
      title: hiveTask.title,
      description: hiveTask.description,
      dueDate: hiveTask.dueDate,
      dueTime: hiveTask.dueTime,
      priority: hiveTask.priority,
      subTasks: hiveTask.subTasks
          .map((subTask) => SubTaskModel.fromHiveModel(subTask))
          .toList(),
    );
  }
  
  // Convert to Hive model
  Task toHiveModel() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      dueTime: dueTime,
      priority: priority,
      subTasks: subTasks.map((subTask) => subTask.toHiveModel()).toList(),
    );
  }
}