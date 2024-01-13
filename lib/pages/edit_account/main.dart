import 'package:finease/core/extensions/text_style_extension.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';

class EditAccountScreen extends StatefulWidget {
  final int accountID;

  const EditAccountScreen({
    super.key,
    required this.accountID,
  });

  @override
  EditAccountScreenState createState() => EditAccountScreenState();
}

class EditAccountScreenState extends State<EditAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit account", style: context.titleMedium),
      ),
      body: Container(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBigButton(
            onPressed: () => {},
            title: "Update",
          ),
        ),
      ),
    );
  }
}
