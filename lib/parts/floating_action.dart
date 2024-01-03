import 'package:finease/parts/variable_fab_size.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeFloatingActionButtonWidget extends StatelessWidget {
  const HomeFloatingActionButtonWidget({
    super.key,
  });

  void _handleClick(BuildContext context, int page) {
    switch (page) {
      case 1:
        context.goNamed(RoutesName.addAccount.name);
        break;
      case 6:
        context.pushNamed(RoutesName.addAccount.name);
        break;
      case 0:
        context.pushNamed(RoutesName.addAccount.name);
        break;
      case 4:
        context.goNamed(RoutesName.addAccount.name);
        break;
      case 2:
        context.goNamed(RoutesName.addAccount.name);
        break;
      case 5:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VariableFABSize(
      onPressed: () => _handleClick,
      icon: Icons.add,
    );
  }
}
