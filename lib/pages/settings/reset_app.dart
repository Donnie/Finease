import 'package:finease/db/db.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetAppWidget extends StatefulWidget {
  const ResetAppWidget({super.key});

  @override
  State<ResetAppWidget> createState() => _ResetAppWidgetState();
}

class _ResetAppWidgetState extends State<ResetAppWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Reset App"),
      leading: const Icon(Icons.delete_forever),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text("Reset App"),
            content: const Text("Are you sure you want to wipe all data in this App? This action cannot be undone!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              TextButton(
                child: const Text("Reset App"),
                onPressed: () async {
                  await DatabaseHelper().clearDatabase().then((value) {
                    Navigator.of(dialogContext).pop(false);
                    context.pop();
                    context.go(RoutesName.intro.path);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
