import 'package:finease/db/db.dart';
import 'package:finease/pages/settings/setting_option.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';
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
    return SettingsOption(
      title: language["resetApp"],
      icon: Icons.delete_forever,
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text(language["resetApp"]),
            content: Text(language["resetAppInfo"]),
            actions: <Widget>[
              TextButton(
                child: Text(language["cancel"]),
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              TextButton(
                child: Text(language["resetApp"]),
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
