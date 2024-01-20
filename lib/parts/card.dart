import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.elevation,
    this.color,
    this.shape,
  });

  final Widget child;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
      color: color ?? context.surfaceVariant,
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 2.0,
      shadowColor: color ?? context.shadow,
      child: child,
    );
  }
}
