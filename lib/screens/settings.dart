import 'package:dbapp/widgets/switch.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkThemeEnabled = false;
  bool defaultRemindersEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Deep purple color
        title: const Text('Settings', style: TextStyle(color: Colors.white)),

        elevation: 0,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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
