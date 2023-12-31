import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:finease/core/common.dart';

class FineaseBigButton extends StatelessWidget {
  const FineaseBigButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        foregroundColor: context.onPrimary,
        backgroundColor: context.primary,
      ),
      child: Text(
        title,
        style: context.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.onPrimary,
        ),
      ),
    );
  }
}

class FineaseButton extends StatelessWidget {
  const FineaseButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        foregroundColor: context.onPrimary,
        backgroundColor: context.primary,
      ),
      child: Text(title),
    );
  }
}

class FineaseIconButton extends StatelessWidget {
  const FineaseIconButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.iconData,
  });

  final IconData iconData;
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        foregroundColor: context.onPrimary,
        backgroundColor: context.primary,
      ),
      label: Text(title),
      icon: Icon(iconData),
    );
  }
}

class FineaseTextButton extends StatelessWidget {
  const FineaseTextButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        foregroundColor: context.primary,
      ),
      child: Text(title),
    );
  }
}

class FineaseOutlineButton extends StatelessWidget {
  const FineaseOutlineButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        foregroundColor: context.primary,
      ),
      child: Text(title),
    );
  }
}

class FineaseOutlineIconButton extends StatelessWidget {
  const FineaseOutlineIconButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        foregroundColor: context.primary,
      ),
      label: Text(title),
      icon: Icon(MdiIcons.sortVariant),
    );
  }
}
