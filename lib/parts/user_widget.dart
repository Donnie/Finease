import 'package:finease/core/export.dart';
import 'package:flutter/material.dart';

class AppUserWidget extends StatelessWidget {
  const AppUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: ClipOval(
        child: Container(
          width: 32,
          height: 32,
          color: context.secondaryContainer,
          child: Icon(
            Icons.account_circle_outlined,
            color: context.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
