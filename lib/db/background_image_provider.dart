import 'package:finease/db/background_images.dart';
import 'package:flutter/foundation.dart';

/// Provider for managing background image state across the app
/// Uses ChangeNotifier to notify listeners when background changes
class BackgroundImageProvider extends ChangeNotifier {
  final BackgroundImageService _backgroundService = BackgroundImageService();
  String? _currentBackground;
  bool _isLoading = true;

  String? get currentBackground => _currentBackground;
  bool get isLoading => _isLoading;

  /// Initialize and load the current background from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentBackground = await _backgroundService.getSelectedBackground();
    } catch (e) {
      debugPrint('Error loading background: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set a new background image and notify all listeners
  Future<void> setBackground(String imagePath) async {
    try {
      await _backgroundService.setSelectedBackground(imagePath);
      _currentBackground = imagePath;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting background: $e');
      rethrow;
    }
  }

  /// Reload the background from storage
  Future<void> reload() async {
    try {
      final newBackground = await _backgroundService.getSelectedBackground();
      if (newBackground != _currentBackground) {
        _currentBackground = newBackground;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error reloading background: $e');
    }
  }

  /// Get all available backgrounds
  Future<List<String>> getAllBackgrounds() async {
    return await _backgroundService.getAllBackgroundImages();
  }

  /// Add a custom background image
  Future<String?> addCustomBackground(String sourceFilePath) async {
    final addedPath = await _backgroundService.addCustomBackgroundImage(sourceFilePath);
    if (addedPath != null) {
      notifyListeners();
    }
    return addedPath;
  }

  /// Remove a custom background image
  Future<bool> removeCustomBackground(String imagePath) async {
    final removed = await _backgroundService.removeCustomBackgroundImage(imagePath);
    if (removed) {
      // If the removed image was current, reload to get the new current
      if (_currentBackground == imagePath) {
        await reload();
      } else {
        notifyListeners();
      }
    }
    return removed;
  }

  /// Check if an image is a default image
  bool isDefaultImage(String imagePath) {
    return _backgroundService.isDefaultImage(imagePath);
  }

  /// Get display name for an image
  String getImageDisplayName(String imagePath) {
    return _backgroundService.getImageDisplayName(imagePath);
  }
}

