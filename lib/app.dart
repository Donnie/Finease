import 'package:finease/routes/routes.dart';
import 'package:finease/core/constants/constants.dart';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:finease/core/theme/app_theme.dart';
import 'package:finease/core/theme/theme_provider.dart';
import 'package:finease/db/background_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundImageProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => GlassmorphicOpacityProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => GlassmorphicBlurProvider()..initialize()),
      ],
      child: const _MainAppContent(),
    );
  }
}

class _MainAppContent extends StatelessWidget {
  const _MainAppContent();

  @override
  Widget build(BuildContext context) {
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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Get custom colors from theme provider
        final lightColorScheme = themeProvider.lightColorTheme.toColorScheme(Brightness.light);
        final darkColorScheme = themeProvider.darkColorTheme.toColorScheme(Brightness.dark);

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
  }
}
