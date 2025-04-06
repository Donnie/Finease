import 'package:flutter/material.dart';
import 'package:finease/db/settings.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingService _settingService = SettingService();
  bool _isDarkMode = false;
  bool _isLoading = true;
  bool _isChanging = false;

  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  bool get isChanging => _isChanging;

  ThemeProvider() {
    _loadDarkModeSetting();
  }

  Future<void> _loadDarkModeSetting() async {
    try {
      final darkMode = await _settingService.getSetting(Setting.darkMode);
      _isDarkMode = darkMode == "true";
    } catch (e) {
      // Handle any errors during loading
      _isDarkMode = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    if (_isDarkMode == value || _isChanging) return; // No change needed or already changing
    
    _isChanging = true;
    notifyListeners(); // Notify that we're about to change
    
    try {
      // Update the UI first for immediate feedback
      _isDarkMode = value;
      notifyListeners();
      
      // Then save to the database
      await _settingService.setSetting(Setting.darkMode, value.toString());
    } catch (e) {
      // If saving fails, revert the change
      _isDarkMode = !value;
      notifyListeners();
      // You could show a snackbar or dialog here to inform the user
    } finally {
      _isChanging = false;
      notifyListeners();
    }
  }
} 
