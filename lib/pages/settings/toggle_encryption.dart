import 'package:finease/db/settings.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class ToggleEncryptionWidget extends StatefulWidget {
  const ToggleEncryptionWidget({super.key});

  @override
  ToggleEncryptionWidgetState createState() => ToggleEncryptionWidgetState();
}

class ToggleEncryptionWidgetState extends State<ToggleEncryptionWidget> {
  final SettingService _settingService = SettingService();
  bool _useEncryption = false;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    String useEncryptionStr = await _settingService.getSetting(Setting.useEncryption);
    _useEncryption = useEncryptionStr == "true";
    setState(() {});
  }

  Future<void> _askForPassword() async {
    String password = '';
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Enable Encryption"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return TextField(
              decoration: const InputDecoration(hintText: "Enter a strong password"),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: estimatePasswordStrength(password) > 0.8 // Checking if the password is strong
                ? () {
                    Navigator.of(dialogContext).pop();
                    _settingService.setSetting(Setting.dbPassword, password);
                    _settingService.setSetting(Setting.useEncryption, "true");
                    setState(() {
                      _useEncryption = true;
                    });
                  }
                : null,
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDisable() async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Disable Encryption"),
        content: const Text("Disabling encryption will remove encryption from your exported database."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _useEncryption = true; // Don't change the toggle if cancelled
              });
            },
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () {
              confirm = true;
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );

    if (confirm) {
      _settingService.setSetting(Setting.useEncryption, "false");
      _settingService.setSetting(Setting.dbPassword, ""); // Clear the password
      setState(() {
        _useEncryption = false;
      });
    }
  }

  Future<void> _handleEncryptionToggle(bool value) async {
    if (value) {
      // Show password dialog if true
      await _askForPassword();
    } else {
      // Confirm before disabling encryption
      await _confirmDisable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Encryption'),
      subtitle: const Text('Use encryption for your database'),
      trailing: Switch(
        value: _useEncryption,
        onChanged: (value) => _handleEncryptionToggle(value),
      ),
    );
  }
}
