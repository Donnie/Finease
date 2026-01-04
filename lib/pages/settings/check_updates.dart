import 'package:finease/core/export.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finease/core/version_checker.dart';

class CheckUpdatesWidget extends StatefulWidget {
  const CheckUpdatesWidget({super.key});

  @override
  State<CheckUpdatesWidget> createState() => _CheckUpdatesWidgetState();
}

class _CheckUpdatesWidgetState extends State<CheckUpdatesWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Check Updates'),
      leading: const Icon(Icons.system_update),
      onTap: () => _checkForUpdates(context),
    );
  }

  Future<void> _checkForUpdates(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text('Checking for updates...'),
            ],
          ),
        );
      },
    );

    try {
      // Get current version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Check for new tags
      final checker = VersionChecker(
        owner: 'Donnie',
        repo: 'Finease',
      );

      final latestTag = await checker.getLatestTag();
      final newTag = await checker.checkForNewTag(currentVersion);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show result dialog
      if (context.mounted) {
        _showUpdateDialog(context, currentVersion, latestTag, newTag);
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (context.mounted) {
        _showErrorDialog(context);
      }
    }
  }

  void _showUpdateDialog(
    BuildContext context,
    String currentVersion,
    String? latestTag,
    String? newTag,
  ) {
    final hasUpdate = newTag != null;
    final tagToShow = latestTag ?? 'Unknown';
    final versionToShow = latestTag?.replaceFirst(RegExp(r'^v'), '') ?? 'Unknown';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hasUpdate ? 'Update Available' : 'You\'re up to date!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Current version: $currentVersion'),
                const SizedBox(height: 8.0),
                Text('Latest version: $versionToShow'),
                if (hasUpdate) ...[
                  const SizedBox(height: 16.0),
                  const Text('A new version is available!'),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      final downloadUrl =
                          'https://github.com/Donnie/Finease/releases/download/$tagToShow/finease-$tagToShow.apk';
                      launchUrl(Uri.parse(downloadUrl));
                    },
                    child: Text(
                      'Download $tagToShow',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: context.primary,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16.0),
                  const Text('You have the latest version.'),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Okie!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'Failed to check for updates.\n\n'
            'Please check your internet connection and try again.',
          ),
          actions: [
            TextButton(
              child: const Text('Okie!'),
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

