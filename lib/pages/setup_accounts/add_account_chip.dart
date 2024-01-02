import 'package:finease/core/common.dart';
import 'package:finease/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddAccountChip extends StatelessWidget {
  const AddAccountChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: false,
      onSelected: (value) {
        context.pushNamed(RoutesName.addAccount.name);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          width: 1,
          color: context.primary,
        ),
      ),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(language["addAccount"]),
      labelStyle: context.titleMedium,
      padding: const EdgeInsets.all(12),
      avatar: Icon(
        Icons.add_rounded,
        color: context.primary,
      ),
    );
  }
}
