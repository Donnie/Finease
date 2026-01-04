import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';

class GlassmorphicCard extends StatelessWidget {
  const GlassmorphicCard({
    super.key,
    required this.child,
    this.elevation,
    this.shape,
    this.blurAmount = 10.0,
    this.opacity = 0.15,
  });

  final Widget child;
  final double? elevation;
  final ShapeBorder? shape;
  final double blurAmount;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          decoration: BoxDecoration(
            color: context.surface.withOpacity(opacity),
            borderRadius: BorderRadius.circular(16),
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

