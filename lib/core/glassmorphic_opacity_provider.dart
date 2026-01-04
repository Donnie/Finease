import 'package:finease/db/settings.dart';
import 'package:flutter/foundation.dart';

/// Provider for managing glassmorphic opacity across the app
class GlassmorphicOpacityProvider extends ChangeNotifier {
  final SettingService _settingService = SettingService();
  double _opacity = 0.25; // Default opacity
  bool _isLoading = true;

  double get opacity => _opacity;
  bool get isLoading => _isLoading;

  /// Initialize and load the opacity from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final opacityString = await _settingService.getSetting(Setting.glassmorphicOpacity);
      if (opacityString.isNotEmpty) {
        _opacity = double.tryParse(opacityString) ?? 0.25;
      }
    } catch (e) {
      debugPrint('Error loading glassmorphic opacity: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set a new opacity value and notify all listeners
  Future<void> setOpacity(double opacity) async {
    try {
      await _settingService.setSetting(Setting.glassmorphicOpacity, opacity.toString());
      _opacity = opacity;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting glassmorphic opacity: $e');
      rethrow;
    }
  }
}

