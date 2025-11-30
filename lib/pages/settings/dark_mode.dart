import 'package:finease/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModeToggleWidget extends StatelessWidget {
  final Function onChange;
  const DarkModeToggleWidget({
    super.key,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Show loading indicator while theme is loading
        if (themeProvider.isLoading) {
          return const ListTile(
            title: Text("Dark Mode"),
            subtitle: Text("Loading..."),
            leading: CircularProgressIndicator(),
          );
        }

        return SwitchListTile(
          title: const Text("Dark Mode"),
          subtitle: Text(themeProvider.isDarkMode ? "Enabled" : "Disabled"),
          value: themeProvider.isDarkMode,
          onChanged: (value) async {
            // Show a snackbar to indicate the change
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value
                      ? "Switching to dark mode..."
                      : "Switching to light mode...",
                ),
                duration: const Duration(seconds: 1),
              ),
            );

            // Toggle the theme
            await themeProvider.toggleDarkMode(value).then((value) {
              Navigator.pop(context); // Close the settings page
            });

            // Call the onChange callback
            onChange();
          },
          secondary: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
