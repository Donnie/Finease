import 'dart:ui';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';
import 'package:provider/provider.dart';

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
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    
    return ClipRRect(
      borderRadius: shape != null 
          ? BorderRadius.zero 
          : BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? context.surface).withOpacity(opacity),
            borderRadius: shape != null 
                ? null 
                : BorderRadius.circular(16),
            border: Border.all(
              color: context.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
