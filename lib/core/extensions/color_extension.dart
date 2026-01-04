import 'package:flutter/material.dart';

extension ColorHelper on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get error => colorScheme.error;
  Color get errorContainer => colorScheme.errorContainer;
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onError => colorScheme.onError;
  Color get onErrorContainer => colorScheme.onErrorContainer;
  Color get onInverseSurface => colorScheme.onInverseSurface;
  Color get onPrimary => colorScheme.onPrimary;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color get onSurface => colorScheme.onSurface;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get onTertiary => colorScheme.tertiary;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;
  Color get primary => colorScheme.primary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get secondary => colorScheme.secondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get shadow => colorScheme.shadow;
  Color get surface => colorScheme.surface;
  Color get surfaceTint => colorScheme.surfaceTint;
  Color get surfaceVariant => colorScheme.surfaceContainerHighest;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;
  Color get tertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
}
