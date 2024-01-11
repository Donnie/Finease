import 'package:flutter/material.dart';

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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Chat Options',
              style: TextStyle(
                color: Colors.white,
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
