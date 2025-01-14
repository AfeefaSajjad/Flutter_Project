import 'package:flutter/material.dart';
import '../resources/colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth > 600 ? 28 : 24;

    double horizontalPadding = screenWidth > 600 ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {},
                activeColor: AppColors.primaryColor,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {},
                activeColor: AppColors.primaryColor,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('English'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Cache'),
              onTap: () async {
                // await _clearCache();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                _showAppInstructions(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('How to Use This App'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    '1. On the home screen, add a new task using the "+" button.'),
                Text('2. Set the task details like title and description.'),
                Text(
                    '3. You can mark tasks as complete by tapping the checkbox.'),
                Text(
                    '4. Use the filters to organize tasks by completion status.'),
                Text(
                    '5. Update or delete tasks from the task list using the icons.'),
                Text('6. Switch between dark and light modes in the settings.'),
                Text(
                    '7. Manage notifications and language preferences in settings.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.textColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
