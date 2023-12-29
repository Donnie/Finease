import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  final Function onClearDatabase;

  const ChatDrawer({Key? key, required this.onClearDatabase}) : super(key: key);

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
        ],
      ),
    );
  }
}
