import 'package:finease/config/routes_name.dart';
import 'package:finease/core/common.dart';
import 'package:finease/core/widgets/export.dart';
import 'package:finease/core/widgets/lava/lava_clock.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/widgets/intro_features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroMobileWidget extends StatelessWidget {
  const IntroMobileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 0,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: LavaAnimation(
            color: context.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppIcon(size: 52),
                      Text(
                        language["appTitle"],
                        style: context.displayMedium?.copyWith(
                          color: context.primary,
                        ),
                      )
                    ],
                  ),
                  Text(
                    language["introTitle"],
                    style: context.headlineSmall?.copyWith(
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
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
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
    );
  }
}
