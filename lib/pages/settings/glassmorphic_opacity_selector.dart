import 'dart:ui';
import 'package:finease/core/export.dart';
import 'package:finease/core/glassmorphic_opacity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlassmorphicOpacitySelectorWidget extends StatefulWidget {
  const GlassmorphicOpacitySelectorWidget({super.key});

  @override
  State<GlassmorphicOpacitySelectorWidget> createState() =>
      _GlassmorphicOpacitySelectorWidgetState();
}

class _GlassmorphicOpacitySelectorWidgetState
    extends State<GlassmorphicOpacitySelectorWidget> {
  
  Future<void> _showOpacityDialog() async {
    final opacityProvider = context.read<GlassmorphicOpacityProvider>();
    double currentOpacity = opacityProvider.opacity;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Glass Transparency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adjust the transparency of glassmorphic elements',
                style: context.bodyMedium?.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.opacity),
                  Expanded(
                    child: Slider(
                      value: currentOpacity,
                      min: 0.05,
                      max: 0.8,
                      divisions: 30,
                      label: '${(currentOpacity * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          currentOpacity = value;
                        });
                      },
                    ),
                  ),
                  Text('${(currentOpacity * 100).round()}%'),
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
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(currentOpacity),
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
                await opacityProvider.setOpacity(currentOpacity);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Glass transparency updated'),
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
    final opacityProvider = context.watch<GlassmorphicOpacityProvider>();
    
    return ListTile(
      leading: const Icon(Icons.blur_on),
      title: const Text('Glass Transparency'),
      subtitle: Text('${(opacityProvider.opacity * 100).round()}%'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _showOpacityDialog,
    );
  }
}

