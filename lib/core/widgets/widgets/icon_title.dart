import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class AppIconTitle extends StatelessWidget {
  const AppIconTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.wallet,
          color: context.primary,
          size: 32,
        ),
        const SizedBox(width: 16),
        Text(
          language["appTitle"],
          style: context.titleLarge?.copyWith(
            color: context.onBackground,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.size = 32,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.wallet,
      color: context.primary,
      size: size,
    );
  }
}
