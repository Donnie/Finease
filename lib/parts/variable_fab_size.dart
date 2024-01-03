import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VariableFABSize extends StatelessWidget {
  const VariableFABSize({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      tablet: (context) {
        return FloatingActionButton(
          backgroundColor: context.secondaryContainer,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: context.onSecondaryContainer,
          ),
        );
      },
      mobile: (context) {
        return FloatingActionButton.large(
          backgroundColor: context.secondaryContainer,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: context.onSecondaryContainer,
          ),
        );
      },
    );
  }
}
