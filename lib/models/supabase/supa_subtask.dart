// subtask_model.dart
import 'package:dbapp/models/hive/subtask.dart';

class SubTaskModel {
  final int? id;
  final int? taskId;
  final String title;
  final bool isCompleted;
  
  SubTaskModel({
    this.id,
    this.taskId,
    required this.title,
    this.isCompleted = false,
  });
  
  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      id: json['id'],
      taskId: json['task_id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'title': title,
      'is_completed': isCompleted,
    };
  }
  
  // Convert from Hive model
  factory SubTaskModel.fromHiveModel(SubTask hiveSubTask) {
    return SubTaskModel(
      id: hiveSubTask.id,
      title: hiveSubTask.title,
      isCompleted: hiveSubTask.isCompleted,
    );
  }
  
  // Convert to Hive model
  SubTask toHiveModel() {
    return SubTask(
      id: id,
      title: title,
      isCompleted: isCompleted,
    );
  }
}