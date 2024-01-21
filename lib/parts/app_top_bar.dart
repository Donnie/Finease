import 'package:finease/core/export.dart';
import 'package:finease/parts/user_widget.dart';
import 'package:flutter/material.dart';

const double toolbarHeight = kToolbarHeight + 8;

PreferredSize appBar(
  BuildContext context,
  String title,
) =>
    PreferredSize(
      preferredSize: const Size.fromHeight(toolbarHeight),
      child: SafeArea(
        top: true,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            clipBehavior: Clip.antiAlias,
            child: AppBar(
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              automaticallyImplyLeading: true,
              backgroundColor: context.secondaryContainer.withOpacity(0.5),
              scrolledUnderElevation: 0,
              title: Text(title, style: context.titleMedium),
            ),
          ),
        ),
      ),
    );

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
