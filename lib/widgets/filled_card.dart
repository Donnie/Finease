import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class AppFilledCard extends StatelessWidget {
  const AppFilledCard({
    super.key,
    required this.child,
    this.shape,
    this.color,
  });

  final Widget child;
  final Color? color;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: color ?? context.surfaceVariant,
      shadowColor: context.shadow,
      child: child,
    );
  }
}
