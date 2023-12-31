import 'package:dynamic_color/dynamic_color.dart';
import 'package:fineas/config/routes.dart';
import 'package:fineas/core/constants/constants.dart';
import 'package:fineas/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.settings,
  });

  final String settings;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ColorScheme lightColorScheme = const ColorScheme.light();  // default light scheme
  ColorScheme darkColorScheme = const ColorScheme.dark();    // default dark scheme

  ValueNotifier<Map<String, dynamic>> settingsNotifier = ValueNotifier<Map<String, dynamic>>({});
  // Add any state-related properties or methods here
  @override
  void initState() {
    super.initState();
    loadInitialSettings();
  }

  Future<void> loadInitialSettings() async {
    // Provide your logic to retrieve initial settings from the database
    Map<String, dynamic> initialSettings = {};
    settingsNotifier.value = initialSettings;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider<String>(create: (_) => widget.settings),
      ],
      child: ValueListenableBuilder<Map<String, dynamic>>(
        valueListenable: settingsNotifier,
        builder: (context, value, _) {
          const bool isDynamic = false;
          const ThemeMode themeMode = ThemeMode.dark;
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
              if (lightDynamic != null && darkDynamic != null && isDynamic) {
                lightColorScheme = lightDynamic.harmonized();
                darkColorScheme = darkDynamic.harmonized();
              } else {
                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: primaryColor,
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  brightness: Brightness.dark,
                );
              }

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
        },
      ),
    );
  }

  @override
  void dispose() {
    settingsNotifier.dispose();
    super.dispose();
  }
}
