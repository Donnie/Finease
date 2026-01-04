import 'package:finease/db/settings.dart';
import 'package:flutter/foundation.dart';

/// Provider for managing glassmorphic blur amount across the app
class GlassmorphicBlurProvider extends ChangeNotifier {
  final SettingService _settingService = SettingService();
  double _blurAmount = 10.0; // Default blur amount
  bool _isLoading = true;

  double get blurAmount => _blurAmount;
  bool get isLoading => _isLoading;

  /// Initialize and load the blur amount from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final blurString = await _settingService.getSetting(Setting.glassmorphicBlur);
      if (blurString.isNotEmpty) {
        _blurAmount = double.tryParse(blurString) ?? 10.0;
      }
    } catch (e) {
      debugPrint('Error loading glassmorphic blur: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set a new blur amount value and notify all listeners
  Future<void> setBlurAmount(double blurAmount) async {
    try {
      await _settingService.setSetting(Setting.glassmorphicBlur, blurAmount.toString());
      _blurAmount = blurAmount;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting glassmorphic blur: $e');
      rethrow;
    }
  }
}

