import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';

class FeatureList extends StatelessWidget {
  const FeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeatureListItem(title: language["introSummary1"]),
        FeatureListItem(title: language["introSummary2"]),
        FeatureListItem(title: language["introSummary3"]),
      ],
    );
  }
}

class FeatureListItem extends StatelessWidget {
  final String title;

  const FeatureListItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.check_circle,
        color: context.primary,
      ),
      dense: true,
      title: Text(
        title,
        style: context.titleMedium,
      ),
    );
  }
}
