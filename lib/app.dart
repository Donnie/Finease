import 'package:dynamic_color/dynamic_color.dart';
import 'package:finease/routes/routes.dart';
import 'package:finease/core/constants/constants.dart';
import 'package:finease/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ColorScheme lightColorScheme = const ColorScheme.light();
  ColorScheme darkColorScheme = const ColorScheme.dark();

  @override
  Widget build(BuildContext context) {
    const ThemeMode themeMode = ThemeMode.system;
    const int color = 0xFF795548;
    const Color primaryColor = Color(color);
    const Locale locale = Locale('en');
    const String fontPreference = 'Outfit';
    final TextTheme darkTextTheme = GoogleFonts.getTextTheme(
      fontPreference,
      ThemeData.dark().textTheme,
    );

    final TextTheme lightTextTheme = GoogleFonts.getTextTheme(
      fontPreference,
      ThemeData.light().textTheme,
    );

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: primaryColor,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        );

        return MaterialApp.router(
          locale: locale,
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          onGenerateTitle: (BuildContext context) => language["appTitle"],
          theme: appTheme(
            context,
            lightColorScheme,
            fontPreference,
            lightTextTheme,
            ThemeData.light().dividerColor,
            SystemUiOverlayStyle.dark,
          ),
          darkTheme: appTheme(
            context,
            darkColorScheme,
            fontPreference,
            darkTextTheme,
            ThemeData.dark().dividerColor,
            SystemUiOverlayStyle.light,
          ),
        );
      },
    );
  }
}
