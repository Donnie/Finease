import 'dart:convert';
import 'dart:io';
import 'package:finease/db/settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class BackgroundImageService {
  final SettingService _settingService = SettingService();

  // Special value for no background
  static const String noneBackground = 'none';

  // Default built-in images
  static const List<String> defaultImages = [
    'images/nannan.png',
    'images/owl-couple.png',
  ];

  // Get the current selected background image
  Future<String> getSelectedBackground() async {
    final selected = await _settingService.getSetting(Setting.backgroundImage);
    if (selected.isEmpty) {
      return noneBackground; // Default to no background (matches onboarding default)
    }
    return selected;
  }

  // Set the selected background image
  Future<void> setSelectedBackground(String imagePath) async {
    await _settingService.setSetting(Setting.backgroundImage, imagePath);
  }

  // Get list of all available images (default + custom)
  Future<List<String>> getAllBackgroundImages() async {
    final customImages = await getCustomBackgroundImages();
    return [noneBackground, ...defaultImages, ...customImages];
  }

  // Get custom background images
  Future<List<String>> getCustomBackgroundImages() async {
    final customImagesJson = await _settingService.getSetting(Setting.customBackgroundImages);
    if (customImagesJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decoded = jsonDecode(customImagesJson);
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  // Add a custom background image
  Future<String?> addCustomBackgroundImage(String sourceFilePath) async {
    try {
      final File sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      // Get app documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory backgroundsDir = Directory(path.join(appDocDir.path, 'backgrounds'));
      
      // Create backgrounds directory if it doesn't exist
      if (!await backgroundsDir.exists()) {
        await backgroundsDir.create(recursive: true);
      }

      // Generate unique filename
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(sourceFilePath)}';
      final String destinationPath = path.join(backgroundsDir.path, fileName);

      // Copy file to app directory
      await sourceFile.copy(destinationPath);

      // Update custom images list
      final customImages = await getCustomBackgroundImages();
      customImages.add(destinationPath);
      await _saveCustomBackgroundImages(customImages);

      return destinationPath;
    } catch (e) {
      return null;
    }
  }

  // Remove a custom background image
  Future<bool> removeCustomBackgroundImage(String imagePath) async {
    try {
      // Don't allow removing default images
      if (defaultImages.contains(imagePath)) {
        return false;
      }

      // Get custom images list
      final customImages = await getCustomBackgroundImages();
      if (!customImages.contains(imagePath)) {
        return false;
      }

      // Delete the file
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      // Update custom images list
      customImages.remove(imagePath);
      await _saveCustomBackgroundImages(customImages);

      // If the deleted image was selected, switch to default
      final currentSelected = await getSelectedBackground();
      if (currentSelected == imagePath) {
        await setSelectedBackground(defaultImages[0]);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if an image is a default image
  bool isDefaultImage(String imagePath) {
    return defaultImages.contains(imagePath) || imagePath == noneBackground;
  }

  // Save custom background images list
  Future<void> _saveCustomBackgroundImages(List<String> images) async {
    final json = jsonEncode(images);
    await _settingService.setSetting(Setting.customBackgroundImages, json);
  }

  // Get display name for an image
  String getImageDisplayName(String imagePath) {
    if (imagePath == noneBackground) {
      return 'None';
    }
    
    // Get filename without extension
    final filename = path.basenameWithoutExtension(imagePath);
    
    // Replace hyphens and underscores with spaces
    final withSpaces = filename.replaceAll('-', ' ').replaceAll('_', ' ');
    
    // Title case each word
    final words = withSpaces.split(' ');
    final titleCased = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
    
    return titleCased;
  }
}

