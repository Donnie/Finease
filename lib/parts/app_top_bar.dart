import 'dart:ui';
import 'package:finease/core/export.dart';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:finease/parts/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const double toolbarHeight = kToolbarHeight + 8;

// Root routes that should never show a back button
const List<String> _rootRoutes = [
  '/home',
  '/accounts',
  '/months',
  '/transactions',
];

bool _shouldShowBackButton(BuildContext context) {
  if (!GoRouter.of(context).canPop()) {
    return false;
  }
  
  final location = GoRouterState.of(context).uri.path;
  return !_rootRoutes.contains(location);
}

PreferredSize appBar(
  BuildContext context,
  String title,
) {
  final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
  
  return PreferredSize(
    preferredSize: const Size.fromHeight(toolbarHeight),
    child: SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: AppBar(
              leading: _shouldShowBackButton(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              automaticallyImplyLeading: true,
              backgroundColor: context.surface.withOpacity(opacity),
              scrolledUnderElevation: 0,
              title: Text(title, style: context.titleMedium),
            ),
          ),
        ),
      ),
    ),
  );
}

PreferredSize infoBar(
  BuildContext context,
  String title,
  String info, {
  List<Widget>? additionalActions,
}) {
  final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
  
  return PreferredSize(
    preferredSize: const Size.fromHeight(toolbarHeight),
    child: SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: AppBar(
              leading: _shouldShowBackButton(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              automaticallyImplyLeading: true,
              backgroundColor: context.surface.withOpacity(opacity),
              scrolledUnderElevation: 0,
              title: Text(title, style: context.titleMedium),
              actions: [
                if (additionalActions != null) ...additionalActions,
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Information'),
                        content: Text(info),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outlined),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final opacity = context.watch<GlassmorphicOpacityProvider>().opacity;
    
    return SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: AppBar(
              backgroundColor: context.surface.withOpacity(opacity),
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
      ),
    );
  }
}
