import 'dart:io';
import 'package:finease/db/background_images.dart';
import 'package:finease/db/background_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A wrapper widget that adds the background image to any page
class BackgroundWrapper extends StatelessWidget {
  const BackgroundWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundImageProvider>(
      builder: (context, backgroundProvider, _) {
        final backgroundImagePath = backgroundProvider.currentBackground;
        
        return Stack(
          children: [
            // Background - solid color for "none", image otherwise
            if (backgroundImagePath == BackgroundImageService.noneBackground)
              Positioned.fill(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                ),
              )
            else if (backgroundImagePath != null)
              Positioned.fill(
                child: _buildBackgroundImage(
                  backgroundImagePath, 
                  backgroundProvider.isDefaultImage(backgroundImagePath),
                ),
              ),
            // Content
            child,
          ],
        );
      },
    );
  }

  Widget _buildBackgroundImage(String imagePath, bool isDefault) {
    if (isDefault) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default image if custom image fails to load
          return Image.asset(
            BackgroundImageService.defaultImages[0],
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}

