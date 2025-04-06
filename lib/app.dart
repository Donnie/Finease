import 'package:dynamic_color/dynamic_color.dart';
import 'package:finease/routes/routes.dart';
import 'package:finease/core/constants/constants.dart';
import 'package:finease/core/theme/app_theme.dart';
import 'package:finease/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const _MainAppContent(),
    );
  }
}

class _MainAppContent extends StatelessWidget {
  const _MainAppContent();

  @override
  Widget build(BuildContext context) {
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

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp.router(
              locale: locale,
              routerConfig: goRouter,
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
    );
  }
}
