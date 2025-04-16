import 'package:supabase_flutter/supabase_flutter.dart';

class TasksService {
  final SupabaseClient _supabase;
  
  TasksService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;
  
  // Table names
  static const String _tasksTable = 'tasks';
  static const String _subTasksTable = 'sub_tasks';

  // Task operations
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final response = await _supabase
      .from(_tasksTable)
      .select('*, sub_tasks(*)') // Join with sub_tasks
      .order('id', ascending: true);
    
    return response;
  }
  
  Future<Map<String, dynamic>> getTaskById(int taskId) async {
    final response = await _supabase
      .from(_tasksTable)
      .select('*, sub_tasks(*)')
      .eq('id', taskId)
      .single();
    
    return response;
  }
  
  Future<int> createTask({
    required String title,
    String? description,
    required String dueDate,
    required String dueTime,
    required String priority,
    List<Map<String, dynamic>> subTasks = const [],
  }) async {
    // Insert task and get its ID
    final taskResponse = await _supabase
      .from(_tasksTable)
      .insert({
        'title': title,
        'description': description,
        'due_date': dueDate,
        'due_time': dueTime,
        'priority': priority,
      })
      .select('id')
      .single();
    
    final taskId = taskResponse['id'] as int;
    
    // Insert sub-tasks if any
    if (subTasks.isNotEmpty) {
      final subTasksWithTaskId = subTasks.map((subTask) => {
        ...subTask,
        'task_id': taskId,
      }).toList();
      
      await _supabase
        .from(_subTasksTable)
        .insert(subTasksWithTaskId);
    }
    
    return taskId;
  }
  
  Future<void> updateTask({
    required int id,
    String? title,
    String? description,
    String? dueDate,
    String? dueTime,
    String? priority,
  }) async {
    final Map<String, dynamic> updates = {};
    
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (dueDate != null) updates['due_date'] = dueDate;
    if (dueTime != null) updates['due_time'] = dueTime;
    if (priority != null) updates['priority'] = priority;
    
    if (updates.isNotEmpty) {
      await _supabase
        .from(_tasksTable)
        .update(updates)
        .eq('id', id);
    }
  }
  
  Future<void> deleteTask(int taskId) async {
    // Supabase will handle deleting related subtasks with appropriate cascading constraints
    await _supabase
      .from(_tasksTable)
      .delete()
      .eq('id', taskId);
  }
  
  // SubTask operations
  Future<List<Map<String, dynamic>>> getSubTasksForTask(int taskId) async {
    final response = await _supabase
      .from(_subTasksTable)
      .select('*')
      .eq('task_id', taskId)
      .order('id', ascending: true);
    
    return response;
  }
  
  Future<int> createSubTask({
    required int taskId,
    required String title,
    bool isCompleted = false,
  }) async {
    final response = await _supabase
      .from(_subTasksTable)
      .insert({
        'task_id': taskId,
        'title': title,
        'is_completed': isCompleted,
      })
      .select('id')
      .single();
    
    return response['id'] as int;
  }
  
  Future<void> updateSubTask({
    required int id,
    String? title,
    bool? isCompleted,
  }) async {
    final Map<String, dynamic> updates = {};
    
    if (title != null) updates['title'] = title;
    if (isCompleted != null) updates['is_completed'] = isCompleted;
    
    if (updates.isNotEmpty) {
      await _supabase
        .from(_subTasksTable)
        .update(updates)
        .eq('id', id);
    }
  }
  
  Future<void> deleteSubTask(int subTaskId) async {
    await _supabase
      .from(_subTasksTable)
      .delete()
      .eq('id', subTaskId);
  }
}