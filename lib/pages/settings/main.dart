import 'dart:ui';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:finease/pages/export.dart';
import 'package:finease/pages/settings/about.dart';
import 'package:finease/pages/settings/background_image_selector.dart';
import 'package:finease/pages/settings/capital_gains.dart';
import 'package:finease/pages/settings/check_updates.dart';
import 'package:finease/pages/settings/currency.dart';
import 'package:finease/pages/settings/dark_mode.dart';
import 'package:finease/pages/settings/glassmorphic_opacity_selector.dart';
import 'package:finease/pages/settings/glassmorphic_blur_selector.dart';
import 'package:finease/pages/settings/theme_selector.dart';
import 'package:finease/pages/settings/toggle_encryption.dart';
import 'package:finease/parts/export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  void _handleChange(BuildContext context) {
    // Pop back with true to indicate a change was made
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    final blur = context.watch<GlassmorphicBlurProvider>().blurAmount;

    return AppAnnotatedRegionWidget(
      color: Colors.transparent,
      child: BackgroundWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar(context, "settings"),
          body: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SettingsGroup(
                title: "Financial",
                options: [
                  const CapGainsSelectorWidget(),
                  CurrencySelectorWidget(onChange: () => _handleChange(context)),
                ],
              ),
              const SettingsGroup(
                title: "Personalise",
                options: [
                  BackgroundImageSelectorWidget(),
                  DarkModeToggleWidget(),
                  GlassmorphicBlurSelectorWidget(),
                  GlassmorphicOpacitySelectorWidget(),
                  ThemeSelectorWidget(),
                ],
              ),
              SettingsGroup(
                title: "Database",
                options: [
                  const ToggleEncryptionWidget(),
                  const ExportDatabaseWidget(),
                  ImportDatabaseWidget(onImport: () => _handleChange(context)),
                  const ResetAppWidget(),
                ],
              ),
              const SettingsGroup(
                title: "Dev Info",
                options: [
                  AboutWidget(),
                  CheckUpdatesWidget(),
                  VersionWidget(),
                ],
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Theme.of(context).colorScheme.surface.withOpacity(opacity * 0.8),
                                Theme.of(context).colorScheme.surface.withOpacity(opacity * 0.4),
                                Theme.of(context).colorScheme.surface.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.7, 1.0],
                              radius: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Text("Made with ♥ in Berlin"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
