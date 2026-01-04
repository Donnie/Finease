import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:finease/core/export.dart';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:provider/provider.dart';

class GlassmorphicCard extends StatelessWidget {
  const GlassmorphicCard({
    super.key,
    required this.child,
    this.elevation,
    this.shape,
    this.blurAmount,
    this.opacity,
  });

  final Widget child;
  final double? elevation;
  final ShapeBorder? shape;
  final double? blurAmount;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    final effectiveOpacity = opacity ?? context.watch<GlassmorphicOpacityProvider>().opacity;
    final effectiveBlur = blurAmount ?? context.watch<GlassmorphicBlurProvider>().blurAmount;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          decoration: BoxDecoration(
            color: context.surface.withOpacity(effectiveOpacity),
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

