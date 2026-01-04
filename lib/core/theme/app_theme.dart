import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

ThemeData appTheme(
  BuildContext context,
  ColorScheme colorScheme,
  String fontPreference,
  TextTheme textTheme,
  Color dividerColor,
  SystemUiOverlayStyle systemUiOverlayStyle,
) {
  // Apply custom text colors to text theme
  final customTextTheme = textTheme.apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );

  return ThemeData.from(
    colorScheme: colorScheme,
    useMaterial3: true,
  ).copyWith(
    textTheme: customTextTheme,
    colorScheme: colorScheme,
    dialogTheme: dialogTheme(colorScheme),
    timePickerTheme: timePickerTheme,
    appBarTheme: appBarTheme(systemUiOverlayStyle),
    scaffoldBackgroundColor: colorScheme.surface,
    navigationBarTheme: navigationBarThemeData(
      colorScheme,
      customTextTheme,
    ),
    navigationDrawerTheme: navigationDrawerThemeData(
      colorScheme,
      customTextTheme,
    ),
    drawerTheme: drawerThemeData(
      colorScheme,
      customTextTheme,
    ),
    applyElevationOverlayColor: true,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: elevatedButtonTheme(
      context,
      colorScheme,
    ),
    extensions: [lightCustomColor],
    dividerTheme: DividerThemeData(color: dividerColor),
    // Ensure ListTile uses custom text colors
    listTileTheme: ListTileThemeData(
      textColor: colorScheme.onSurface,
      subtitleTextStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    ),
  );
}
