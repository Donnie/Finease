import 'package:finease/config/routes_name.dart';
import 'package:finease/core/common.dart';
import 'package:finease/core/widgets/export.dart';
import 'package:finease/core/widgets/lava/lava_clock.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/widgets/intro_features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroBigScreenWidget extends StatelessWidget {
  const IntroBigScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Material(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(52.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Icon(
                            Icons.wallet,
                            size: 52,
                            color: context.primary,
                          ),
                        ),
                        Text(
                          language["appTitle"],
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: context.primary,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      language["introTitle"],
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: context.onSurface),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeatureListItem(title: language["introSummary1"]),
                        FeatureListItem(title: language["introSummary2"]),
                        FeatureListItem(title: language["introSummary3"]),
                        const SizedBox(height: 24),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            language["usageWarning"],
                            style: context.titleSmall?.copyWith(
                              color: context.bodySmall?.color,
                            ),
                          ),
                        ),
                        AppBigButton(
                          title: language["introCTA"],
                          onPressed: () {
                            SettingService().setSetting(Setting.introDone, "true");
                            context.go(RoutesName.onboarding.path);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: LavaAnimation(
                    color: context.primaryContainer,
                    child: const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
