import 'package:finease/core/common.dart';
import 'package:finease/parts/user_widget.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          child: AppBar(
            backgroundColor: context.secondaryContainer.withOpacity(0.5),
            scrolledUnderElevation: 0,
            title: Text(
              title,
              style: context.titleMedium,
            ),
            actions: const [
              AppUserWidget(),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
