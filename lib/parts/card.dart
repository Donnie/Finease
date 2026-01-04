import 'dart:ui';
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
    return ClipRRect(
      borderRadius: shape != null 
          ? BorderRadius.zero 
          : BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? context.surface).withOpacity(0.25),
            borderRadius: shape != null 
                ? null 
                : BorderRadius.circular(16),
            border: Border.all(
              color: context.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: elevation != null && elevation! > 0
                ? [
                    BoxShadow(
                      color: context.shadow.withOpacity(0.1),
                      blurRadius: elevation!,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
