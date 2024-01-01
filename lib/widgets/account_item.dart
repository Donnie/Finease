import 'package:finease/core/common.dart';
import 'package:finease/db/accounts.dart';
import 'package:finease/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AccountItemWidget extends StatelessWidget {
  const AccountItemWidget({
    super.key,
    required this.account,
    required this.onPress,
  });

  final Account account;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final icon = account.self ? MdiIcons.arrowBottomLeft : MdiIcons.arrowTopRight;
    final color = account.self ? Color(Colors.green.shade200.value) : Color(Colors.red.shade200.value);
    final tileColor = account.liquid ? Color(Colors.brown.shade900.value) : Color(Colors.grey.shade800.value);

    return ScreenTypeLayout.builder(
      mobile: (p0) => ListTile(
        splashColor: tileColor,
        subtitleTextStyle: const TextStyle(fontSize: 12),
        onTap: onPress,
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(account.name),
        subtitle: Text(account.name),
        trailing: Icon(MdiIcons.delete),
      ),
      tablet: (p0) => AppCard(
        color: tileColor,
        child: InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: context.titleMedium,
                      ),
                      Text(
                        account.name,
                        style: context.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
