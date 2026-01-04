import 'dart:ui';
import 'package:finease/core/export.dart';
import 'package:finease/core/glassmorphic_blur_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlassmorphicBlurSelectorWidget extends StatelessWidget {
  const GlassmorphicBlurSelectorWidget({super.key});

  void _showBlurDialog(BuildContext context) {
    final blurProvider = context.read<GlassmorphicBlurProvider>();
    double currentBlur = blurProvider.blurAmount;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Glass Blur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adjust the blur intensity of glassmorphic elements',
                style: context.bodyMedium?.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.blur_on),
                  Expanded(
                    child: Slider(
                      value: currentBlur,
                      min: 0.0,
                      max: 30.0,
                      divisions: 30,
                      label: currentBlur.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() {
                          currentBlur = value;
                        });
                      },
                    ),
                  ),
                  Text(currentBlur.toStringAsFixed(0)),
                ],
              ),
              const SizedBox(height: 16),
              // Preview card
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('images/nannan.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: currentBlur, sigmaY: currentBlur),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Preview',
                          style: context.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await blurProvider.setBlurAmount(currentBlur);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Glass blur updated'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blurProvider = context.watch<GlassmorphicBlurProvider>();
    
    return ListTile(
      leading: const Icon(Icons.blur_circular),
      title: const Text('Glass Blur'),
      subtitle: Text(blurProvider.blurAmount.toStringAsFixed(0)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showBlurDialog(context),
    );
  }
}

