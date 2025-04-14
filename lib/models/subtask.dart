import 'package:hive/hive.dart';

part 'subtask.g.dart'; // Run build_runner to generate the adapter

@HiveType(typeId: 1)
class SubTask {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  SubTask({
    this.id,
    required this.title,
    this.isCompleted = false,
  });
}
