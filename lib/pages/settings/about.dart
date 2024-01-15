import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('About'),
      leading: const Icon(Icons.info_outline),
      onTap: () => _showAboutDialog(context),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text('Finease'),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://github.com/Donnie/Finease'),
                  ),
                  child: const Text(
                    'Free and Open Source',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Privacy-first budgeting.\n\n'
                  'Cultivate discipline,\n'
                  'enjoy ease of use,\n'
                  'and control your financial data,\n'
                  'all with a touch of Berlin ♥',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Yus'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
