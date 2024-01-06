import 'package:finease/parts/variable_fab_size.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FABWidget extends StatelessWidget {
  const FABWidget({
    super.key,
    required this.index,
  });

  final int index;

  static final Map<int, void Function(BuildContext)> _navigationActions = {
    1: (context) => context.pushNamed(RoutesName.addAccount.name),
  };

  void _handleClick(BuildContext context) {
    _navigationActions[index]?.call(context);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _navigationActions[index] != null,
      child: VariableFABSize(
        onPressed: () => _handleClick(context),
        icon: Icons.add,
      ),
    );
  }
}
