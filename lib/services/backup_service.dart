import 'dart:async';
import 'package:dbapp/models/hive/task.dart';
import 'package:dbapp/services/supa_db.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';


class BackupService {
  static const String _backupEnabledKey = 'backup_enabled';
  static const String _nextBackupTimeKey = 'next_backup_time';
  static const String _backupTaskName = 'com.dbapp.backup';
  static const String _taskBoxName = 'tasks';
  
  // Singleton instance
  static final BackupService _instance = BackupService._internal();
  
  factory BackupService() => _instance;
  
  BackupService._internal();
  
  final TasksService _tasksService = TasksService();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  // Initialize backup service
  Future<void> initialize() async {
    // Initialize notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
    
    // Initialize background worker
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    
    // Check if backup is enabled and schedule it if needed
    final prefs = await SharedPreferences.getInstance();
    final backupEnabled = prefs.getBool(_backupEnabledKey) ?? false;
    
    if (backupEnabled) {
      await _checkAndScheduleBackup();
    }
  }
  
  // Toggle backup state
  Future<void> toggleBackup(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backupEnabledKey, enabled);
    
    if (enabled) {
      // Set the next backup time to now (immediate backup)
      final now = DateTime.now();
      await prefs.setString(_nextBackupTimeKey, now.toIso8601String());
      
      // Perform immediate backup
      await _performBackup();
      
      // Schedule next backup in 24 hours
      await _scheduleNextBackup();
    } else {
      // Cancel scheduled backup
      await Workmanager().cancelByUniqueName(_backupTaskName);
    }
  }
  
  // Check backup status
  Future<bool> isBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_backupEnabledKey) ?? false;
  }
  
  // Get next backup time
  Future<DateTime?> getNextBackupTime() async {
    final prefs = await SharedPreferences.getInstance();
    final nextBackupTimeStr = prefs.getString(_nextBackupTimeKey);
    if (nextBackupTimeStr == null) return null;
    
    return DateTime.parse(nextBackupTimeStr);
  }
  
  // Check and schedule backup if needed
  Future<void> _checkAndScheduleBackup() async {
    final nextBackupTime = await getNextBackupTime();
    final now = DateTime.now();
    
    // If next backup time is in the past or not set, do a backup now
    if (nextBackupTime == null || nextBackupTime.isBefore(now)) {
      await _performBackup();
    }
    
    // Schedule the next backup
    await _scheduleNextBackup();
  }
  
  // Schedule the next backup
  Future<void> _scheduleNextBackup() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Calculate next backup time (24 hours from now)
    final now = DateTime.now();
    final nextBackupTime = now.add(const Duration(hours: 24));
    await prefs.setString(_nextBackupTimeKey, nextBackupTime.toIso8601String());
    
    // Schedule the backup task with Workmanager
    await Workmanager().registerOneOffTask(
      _backupTaskName,
      _backupTaskName,
      initialDelay: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  
  // Perform the backup operation
  Future<void> _performBackup() async {
    try {
      // Get tasks from Hive
      final taskBox = await Hive.openBox<Task>(_taskBoxName);
      final tasks = taskBox.values.toList();
      
      // Backup each task to Supabase
      for (final task in tasks) {
        await _backupTask(task);
      }
      
      // Show success notification
      await _showBackupNotification(
        'Backup Complete',
        'Your tasks have been backed up to the cloud',
      );
    } catch (e) {
      // Show error notification
      await _showBackupNotification(
        'Backup Failed',
        'There was an error backing up your tasks: ${e.toString()}',
      );
    }
  }
  
  // Backup a single task to Supabase
  Future<void> _backupTask(Task task) async {
    try {
      // Check if task already exists in Supabase (has ID)
      if (task.id != null) {
        // Try to update the task
        await _tasksService.updateTask(
          id: task.id!,
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          dueTime: task.dueTime,
          priority: task.priority,
        );
        
        // Handle subtasks - first delete existing ones
        final existingSubTasks = await _tasksService.getSubTasksForTask(task.id!);
        for (final subTask in existingSubTasks) {
          await _tasksService.deleteSubTask(subTask['id']);
        }
        
        // Then create new ones
        for (final subTask in task.subTasks) {
          await _tasksService.createSubTask(
            taskId: task.id!,
            title: subTask.title,
            isCompleted: subTask.isCompleted,
          );
        }
      } else {
        // Create new task with subtasks
        final subTasksData = task.subTasks.map((subTask) => {
          'title': subTask.title,
          'is_completed': subTask.isCompleted,
        }).toList();
        
        // Create the task and get its ID
        final newTaskId = await _tasksService.createTask(
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          dueTime: task.dueTime,
          priority: task.priority,
          subTasks: subTasksData,
        );
        
        // Update local task with server ID
        task.id = newTaskId;
        
        // Save updated task back to Hive
        final taskBox = await Hive.openBox<Task>(_taskBoxName);
        await taskBox.put(task.id, task);
      }
    } catch (e) {
      // If update fails, try to create as new
      if (task.id != null) {
        // Create new task and subtasks
        final subTasksData = task.subTasks.map((subTask) => {
          'title': subTask.title,
          'is_completed': subTask.isCompleted,
        }).toList();
        
        final newTaskId = await _tasksService.createTask(
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          dueTime: task.dueTime,
          priority: task.priority,
          subTasks: subTasksData,
        );
        
        // Update local task with new server ID
        task.id = newTaskId;
        
        // Save updated task back to Hive
        final taskBox = await Hive.openBox<Task>(_taskBoxName);
        await taskBox.put(task.id, task);
      }
    }
  }
  
  // Show backup notification
  Future<void> _showBackupNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'backup_channel',
      'Backup Channel',
      channelDescription: 'Notifications related to task backups',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      0,
      title,
      body,
      details,
    );
  }
  
  // Get formatted next backup time
  Future<String> getFormattedNextBackupTime() async {
    final nextBackupTime = await getNextBackupTime();
    if (nextBackupTime == null) return 'Not scheduled';
    
    final formatter = DateFormat('MMM dd, yyyy - hh:mm a');
    return formatter.format(nextBackupTime);
  }
}

// Background task callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Initialize Hive for background tasks
    // Note: You need to register your Hive adapters here as well
    
    if (taskName == BackupService._backupTaskName) {
      final backupService = BackupService();
      final isEnabled = await backupService.isBackupEnabled();
      
      if (isEnabled) {
        await backupService._performBackup();
        await backupService._scheduleNextBackup();
      }
    }
    
    return true;
  });
}