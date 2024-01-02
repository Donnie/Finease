import 'package:flutter/material.dart';
import 'package:finease/core/common.dart';

class IntroTopWidget extends StatelessWidget {
  const IntroTopWidget({
    super.key,
    required this.titleWidget,
    this.description,
    required this.icon,
  });

  final String? description;
  final IconData icon;
  final Widget titleWidget;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              context.primary,
              BlendMode.srcIn,
            ),
            child: Icon(
              icon,
              size: 72,
            ),
          ),
          const SizedBox(height: 16),
          titleWidget,
          const SizedBox(height: 6),
          if (description != null)
            Text(
              description!,
              style: context.titleSmall?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
              ),
            )
          else
            const SizedBox.shrink(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
