import 'package:finease/parts/export.dart';
import 'package:finease/parts/pill_chip.dart';
import 'package:flutter/material.dart';

class AddAccountBody extends StatelessWidget {
  const AddAccountBody({
    super.key,
    required this.formState,
    required this.nameController,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formState,
        child: ListView(
          children: [
            Row(
              children: [
                AppPillChip(
                  isSelected: false,
                  title: "Credit",
                  onPressed: () => {},
                ),
                AppPillChip(
                  isSelected: true,
                  title: "Debit",
                  onPressed: () => {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              key: const Key('account_name_textfield'),
              controller: nameController,
              hintText: 'Enter account name',
              label: 'Enter account name',
              keyboardType: TextInputType.name,
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter account name';
                }
              },
            ),
            const SizedBox(height: 16),
            AppTextFormField(
              key: const Key('account_currency_textfield'),
              controller: nameController,
              hintText: 'Enter currency',
              label: 'Enter currency',
              keyboardType: TextInputType.name,
              validator: (val) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return 'Enter currency';
                }
              },
            ),
            const SizedBox(height: 16),
            _customSwitch('Liquid Assets'),
          ],
        ),
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
