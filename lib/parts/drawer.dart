import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';

class ChatDrawer extends StatelessWidget {
  final Function onClearDatabase;
  final bool isDarkModeEnabled;
  final Function(bool) onToggleDarkMode;

  const ChatDrawer({
    super.key,
    required this.onClearDatabase,
    required this.isDarkModeEnabled,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primary,
            ),
            child: Text(
              'Chat Options',
              style: TextStyle(
                color: context.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear DB'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              onClearDatabase();
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkModeEnabled,
            onChanged: (bool value) {
              Navigator.pop(context); // Close the drawer
              onToggleDarkMode(value);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
        ],
      ),
    );
  }
}
