import 'package:finease/db/settings.dart';
import 'package:finease/parts/password_button.dart';
import 'package:flutter/material.dart';

class ToggleEncryptionWidget extends StatefulWidget {
  const ToggleEncryptionWidget({super.key});

  @override
  ToggleEncryptionWidgetState createState() => ToggleEncryptionWidgetState();
}

class ToggleEncryptionWidgetState extends State<ToggleEncryptionWidget> {
  final SettingService _settingService = SettingService();
  bool _useEncryption = false;
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    String useEncryptionStr =
        await _settingService.getSetting(Setting.useEncryption);
    setState(() {
      _useEncryption = useEncryptionStr == "true";
      _password.text = '';
    });
  }

  Future<void> _confirmPassword() async {
    setState(() {
      _useEncryption = true;
    });
    _settingService.setSetting(Setting.dbPassword, _password.text);
    _settingService.setSetting(Setting.useEncryption, "true");
  }

  Future<void> _askForPassword() async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        key: ValueKey(_password.text),
        title: const Text("Enable Encryption"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This password will be used to encrypt'
                  ' your database only during export.',
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _password,
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "Enter a strong password",
                  ),
                ),
                const SizedBox(height: 16),
                PasswordButton(
                  key: ValueKey(_password.text),
                  password: _password.text,
                  onPressed: () {
                    _confirmPassword();
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDisable() async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Disable Encryption"),
        content: const Text(
          'Disabling encryption will remove encryption'
          ' from your exported databases.',
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(dialogContext).pop();
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
      await _askForPassword();
      return;
    }
    await _confirmDisable();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.enhanced_encryption),
      key: ValueKey(_password.text),
      title: const Text('Enable Encryption'),
      trailing: Switch(
        value: _useEncryption,
        onChanged: (value) => _handleEncryptionToggle(value),
      ),
    );
  }
}
