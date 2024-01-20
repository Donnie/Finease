import 'package:finease/routes/routes_name.dart';
import 'package:finease/core/export.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/parts/lava/lava_clock.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/parts/intro_features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroTabletWidget extends StatelessWidget {
  const IntroTabletWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: Colors.transparent,
      child: ColoredBox(
        color: context.surface,
        child: LavaAnimation(
          color: context.primaryContainer,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 0,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const AppIcon(size: 52),
                        Text(
                          language["appTitle"],
                          textAlign: TextAlign.center,
                          style: context.displayMedium?.copyWith(
                            color: context.onSurface.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      language["introTitle"],
                      textAlign: TextAlign.center,
                      style: context.headlineMedium?.copyWith(
                        color: context.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const FeatureList(),
                    const Spacer(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        language["usageWarning"],
                        style: context.titleSmall?.copyWith(
                          color: context.bodySmall?.color,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
                child: AppBigButton(
                  onPressed: () {
                    SettingService().setSetting(Setting.introDone, "true");
                    context.go(RoutesName.addName.path);
                  },
                  title: language["introCTA"],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
