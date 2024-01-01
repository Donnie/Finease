import 'package:finease/core/common.dart';
import 'package:finease/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AccountItemWidget extends StatelessWidget {
  const AccountItemWidget({
    super.key,
    this.bankName,
    this.color,
    required this.icon,
    this.name,
    required this.onPress,
  });

  final int? color;
  final String? bankName;
  final IconData icon;
  final String? name;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => ListTile(
        onTap: onPress,
        leading: Icon(
          icon,
          color: Color(color ?? Colors.brown.shade200.value),
        ),
        title: Text(bankName ?? ''),
        subtitle: Text(name ?? ''),
        trailing: Icon(MdiIcons.delete),
      ),
      tablet: (p0) => AppCard(
        child: InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    icon,
                    color: Color(color ?? Colors.brown.shade200.value),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? '',
                        style: context.titleMedium,
                      ),
                      Text(
                        bankName ?? '',
                        style: context.titleMedium,
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
