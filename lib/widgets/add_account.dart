import 'package:finease/core/common.dart';
import 'package:finease/core/widgets/export.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/widgets/account_item.dart';
import 'package:finease/widgets/filled_card.dart';
import 'package:finease/widgets/intro_top.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class IntroAccountAddWidget extends StatefulWidget {
  const IntroAccountAddWidget({
    super.key,
  });

  @override
  State<IntroAccountAddWidget> createState() => _IntroAccountAddWidgetState();
}

class _IntroAccountAddWidgetState extends State<IntroAccountAddWidget>
    with AutomaticKeepAliveClientMixin {

  ValueNotifier<Settings> settingsNotifier = ValueNotifier<Settings>({});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            IntroTopWidget(
              titleWidget: Text(
                language["setupAccounts"],
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.onSurface,
                ),
              ),
              icon: Icons.credit_card_outlined,
            ),
            ValueListenableBuilder<Settings>(
              valueListenable: settingsNotifier,
              builder: (context, value, child) {

                return ScreenTypeLayout.builder(
                  mobile: (p0) => AppFilledCard(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AccountItemWidget(
                          icon: MdiIcons.creditCard,
                          onPress: () {},
                        );
                      },
                    ),
                  ),
                  tablet: (p0) => GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      childAspectRatio: 2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AccountItemWidget(
                        icon: MdiIcons.creditCard,
                        onPress: () async {},
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                language["recommendedAccounts"],
                style: context.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16,
              ),
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  FilterChip(
                    selected: false,
                    onSelected: (value) {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                      side: BorderSide(
                        width: 1,
                        color: context.primary,
                      ),
                    ),
                    showCheckmark: false,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(language["addAccount"]),
                    labelStyle: context.titleMedium,
                    padding: const EdgeInsets.all(12),
                    avatar: Icon(
                      Icons.add_rounded,
                      color: context.primary,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
