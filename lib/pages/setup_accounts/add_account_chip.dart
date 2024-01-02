import 'package:finease/core/common.dart';
import 'package:flutter/material.dart';

class AddAccountChip extends StatelessWidget {
  const AddAccountChip({
    super.key,
    required this.onSelected,
  });

  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: false,
      onSelected: (value) {
        onSelected();
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
