import 'package:dbapp/widgets/switch.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/services/backup_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool cloudBackupEnabled = false;
  bool notificationsEnabled = true;
  bool darkThemeEnabled = false;
  bool defaultRemindersEnabled = false;
  String nextBackupTime = 'Not scheduled';
  final BackupService _backupService = BackupService();

  @override
  void initState() {
    super.initState();
    _loadBackupSettings();
  }

  Future<void> _loadBackupSettings() async {
    // Initialize backup service
    await _backupService.initialize();
    
    // Get backup status
    final isEnabled = await _backupService.isBackupEnabled();
    
    // Get next backup time if backup is enabled
    if (isEnabled) {
      final formattedTime = await _backupService.getFormattedNextBackupTime();
      setState(() {
        cloudBackupEnabled = isEnabled;
        nextBackupTime = formattedTime;
      });
    } else {
      setState(() {
        cloudBackupEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile section
            Row(
              children: [
                // Circle avatar with initials
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Name and email
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'john.doe@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit icon
                Icon(Icons.edit, color: Colors.grey[600]),
              ],
            ),

            const SizedBox(height: 32),
            
            // Cloud Backup Section with next backup info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingSwitch(
                  title: 'Backup to cloud',
                  value: cloudBackupEnabled,
                  onChanged: (val) async {
                    // Toggle backup service
                    await _backupService.toggleBackup(val);
                    
                    // Get next backup time if enabled
                    String formattedTime = 'Not scheduled';
                    if (val) {
                      formattedTime = await _backupService.getFormattedNextBackupTime();
                    }
                    
                    setState(() {
                      cloudBackupEnabled = val;
                      nextBackupTime = formattedTime;
                    });
                  },
                ),
                if (cloudBackupEnabled)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 8.0),
                    child: Text(
                      'Next backup: $nextBackupTime',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
            
            const Divider(height: 1),
            
            SettingSwitch(
              title: 'Notifications',
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
              },
            ),

            const Divider(height: 1),

            SettingSwitch(
              title: 'Dark Mode',
              value: darkThemeEnabled,
              onChanged: (val) {
                setState(() {
                  darkThemeEnabled = val;
                });
              },
            ),

            const Divider(height: 1),

            SettingSwitch(
              title: 'Default Reminders',
              value: defaultRemindersEnabled,
              onChanged: (val) {
                setState(() {
                  defaultRemindersEnabled = val;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}