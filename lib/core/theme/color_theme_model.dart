import 'dart:convert';
import 'package:flutter/material.dart';

/// Model to store custom theme colors
/// 
/// These 7 base colors control the entire app's color scheme through Material 3's
/// color system, which automatically generates additional color variants.
/// 
/// Color Usage Breakdown:
/// 
/// **Primary** (Highly Used - 31 times)
/// - Main brand color for buttons, links, and key UI elements
/// - Auto-generates: primaryContainer, onPrimary, onPrimaryContainer
/// 
/// **Secondary** (Container Used - 11 times) 
/// - Supporting accent for containers, chips, FABs, and app bars
/// - Used for expense/neutral items
/// - Auto-generates: secondaryContainer (used for badges, FABs, app bars, expense items)
/// 
/// **Tertiary** (Container Used - 3 times)
/// - Additional accent for success/positive states
/// - Used for income/positive indicators and as fallback for "green" states
/// - Auto-generates: tertiaryContainer (used for income entries, success states)
/// 
/// **Surface** (Highly Used - 17 times)
/// - Main background color for pages, cards, and surfaces
/// - Auto-generates: surfaceVariant, surfaceContainerHighest, surfaceTint, onSurface
/// 
/// **Error** (Moderately Used - 5 times)
/// - Error, warning, and negative indicator color
/// - Used for validation errors and negative states
/// - Auto-generates: errorContainer, onError, onErrorContainer
/// 
/// **Text** (maps to onSurface - Highly Used - 28 times)
/// - Primary text color throughout the app
/// 
/// **Subtext** (maps to onSurfaceVariant - Highly Used - 27 times)
/// - Secondary text for labels, subtitles, and less prominent text
class ColorThemeModel {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceColor;
  final Color errorColor;
  final Color textColor;
  final Color subtextColor;

  const ColorThemeModel({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceColor,
    required this.errorColor,
    required this.textColor,
    required this.subtextColor,
  });

  // Default theme colors (brown-based)
  static const ColorThemeModel defaultLight = ColorThemeModel(
    primaryColor: Color(0xFF795548),
    secondaryColor: Color(0xFF8D6E63),
    tertiaryColor: Color(0xFFA1887F),
    surfaceColor: Color(0xFFFFFBFE),
    errorColor: Color(0xFFB3261E),
    textColor: Color(0xFF1C1B1F),
    subtextColor: Color(0xFF49454F),
  );

  static const ColorThemeModel defaultDark = ColorThemeModel(
    primaryColor: Color(0xFF795548),
    secondaryColor: Color(0xFF8D6E63),
    tertiaryColor: Color(0xFFA1887F),
    surfaceColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFF2B8B5),
    textColor: Color(0xFFE6E1E5),
    subtextColor: Color(0xFFCAC4D0),
  );

  // Convert to JSON string for storage
  String toJson() {
    return jsonEncode({
      'primary': primaryColor.value,
      'secondary': secondaryColor.value,
      'tertiary': tertiaryColor.value,
      'surface': surfaceColor.value,
      'error': errorColor.value,
      'text': textColor.value,
      'subtext': subtextColor.value,
    });
  }

  // Create from JSON string
  factory ColorThemeModel.fromJson(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return ColorThemeModel(
        primaryColor: Color(json['primary'] as int),
        secondaryColor: Color(json['secondary'] as int),
        tertiaryColor: Color(json['tertiary'] as int),
        surfaceColor: Color(json['surface'] as int),
        errorColor: Color(json['error'] as int),
        textColor: Color(json['text'] as int),
        subtextColor: Color(json['subtext'] as int),
      );
    } catch (e) {
      // Return default if parsing fails
      return defaultLight;
    }
  }

  // Create a ColorScheme from this model
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      error: errorColor,
      onSurface: textColor,
      onSurfaceVariant: subtextColor,
    );
  }

  ColorThemeModel copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? surfaceColor,
    Color? errorColor,
    Color? textColor,
    Color? subtextColor,
  }) {
    return ColorThemeModel(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      errorColor: errorColor ?? this.errorColor,
      textColor: textColor ?? this.textColor,
      subtextColor: subtextColor ?? this.subtextColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorThemeModel &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.tertiaryColor == tertiaryColor &&
        other.surfaceColor == surfaceColor &&
        other.errorColor == errorColor &&
        other.textColor == textColor &&
        other.subtextColor == subtextColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      primaryColor,
      secondaryColor,
      tertiaryColor,
      surfaceColor,
      errorColor,
      textColor,
      subtextColor,
    );
  }
}

