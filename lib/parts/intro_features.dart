import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class FeatureList extends StatelessWidget {
  const FeatureList({Key? key}) : super(key: key);

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

  const FeatureListItem({Key? key, required this.title}) : super(key: key);

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
