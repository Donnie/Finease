import 'package:finease/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class PasswordButton extends StatelessWidget {
  final String password;
  final VoidCallback onPressed;
  final bool? strictMode;

  const PasswordButton({
    super.key,
    required this.password,
    required this.onPressed,
    this.strictMode,
  });

  @override
  Widget build(BuildContext context) {
    double strength = estimatePasswordStrength(password);
    bool strong = strength > 0.8;
    bool strict = strictMode ?? false;
    bool okay = !strict || (strong && strict);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          key: ValueKey(password),
          value: strength,
          minHeight: 2.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            strong ? Colors.green : Colors.red,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.pressed) && strong) {
                  return context.primary.withOpacity(0.2);
                }
                return null;
              },
            ),
          ),
          onPressed: okay ? onPressed : null,
          child: const Text('Confirm Password'),
        ),
      ],
    );
  }
}
