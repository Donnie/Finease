import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Tabs for Cash, Bank, Wallet could be implemented as toggle buttons or a segmented control.
            _accountTypeButton('Cash', true), // Selected
            _accountTypeButton('Bank', false),
            _accountTypeButton('Wallet', false),
            const SizedBox(height: 16),
            // Text fields for cardholder name, account name, and amount.
            _customTextField('Enter cardholder name'),
            const SizedBox(height: 16),
            _customTextField('Enter account name'),
            const SizedBox(height: 16),
            _customTextField('Enter amount'),
            const SizedBox(height: 16),
            // Switches for default and exclude account.
            _customSwitch('Default account'),
            _customSwitch('Exclude account'),
            const SizedBox(height: 16),
            // Color picker placeholder.
            ListTile(
              title: const Text('Pick color'),
              subtitle: const Text('Set color to your category'),
              trailing: const Icon(Icons.circle, color: Colors.red), // Example color
              onTap: () {}, // Placeholder for color picker action
            ),
            const SizedBox(height: 16),
            // Currency selector placeholder.
            ListTile(
              title: const Text('Select currency'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {}, // Placeholder for currency selector action
            ),
            const SizedBox(height: 16),
            // Add account button.
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Theme.of(context).accentColor,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                textStyle: const TextStyle(fontSize: 20.0),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountTypeButton(String title, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        // Placeholder for button action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.grey,
        foregroundColor: Colors.white,
      ),
      child: Text(title),
    );
  }

  Widget _customTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _customSwitch(String label) {
    return SwitchListTile(
      title: Text(label),
      value: false,
      onChanged: (bool value) {
        // Placeholder for switch action
      },
    );
  }
}
