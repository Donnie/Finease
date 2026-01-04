import 'package:flutter/material.dart';

extension ColorHelper on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // Primary colors - main brand color
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  
  // Secondary colors - supporting accents
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  
  // Tertiary colors - additional accents
  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  
  // Surface colors - backgrounds and cards
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;
  Color get surfaceVariant => colorScheme.surfaceContainerHighest; // Alias for compatibility
  Color get surfaceTint => colorScheme.surfaceTint;
  
  // Error colors - warnings and errors
  Color get error => colorScheme.error;
  
  // Outline colors - borders and dividers
  Color get outline => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;
  
  // Shadow
  Color get shadow => colorScheme.shadow;
}
