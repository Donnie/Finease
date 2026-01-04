import 'package:flutter/material.dart';
import 'package:finease/db/settings.dart';
import 'package:finease/core/theme/color_theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingService _settingService = SettingService();
  bool _isDarkMode = false;
  bool _isLoading = true;
  bool _isChanging = false;
  ColorThemeModel _lightColorTheme = ColorThemeModel.defaultLight;
  ColorThemeModel _darkColorTheme = ColorThemeModel.defaultDark;

  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  bool get isChanging => _isChanging;
  ColorThemeModel get lightColorTheme => _lightColorTheme;
  ColorThemeModel get darkColorTheme => _darkColorTheme;
  ColorThemeModel get currentColorTheme => 
      _isDarkMode ? _darkColorTheme : _lightColorTheme;

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final darkMode = await _settingService.getSetting(Setting.darkMode);
      _isDarkMode = darkMode == "true";

      // Load custom colors for light theme
      final lightPrimary = await _settingService.getSetting(Setting.themePrimaryColor);
      if (lightPrimary.isNotEmpty) {
        final lightSecondary = await _settingService.getSetting(Setting.themeSecondaryColor);
        final lightTertiary = await _settingService.getSetting(Setting.themeTertiaryColor);
        final lightSurface = await _settingService.getSetting(Setting.themeSurfaceColor);
        final lightError = await _settingService.getSetting(Setting.themeErrorColor);
        final lightText = await _settingService.getSetting(Setting.themeTextColor);
        final lightSubtext = await _settingService.getSetting(Setting.themeSubtextColor);
        
        if (lightSecondary.isNotEmpty && lightTertiary.isNotEmpty && 
            lightSurface.isNotEmpty && lightError.isNotEmpty &&
            lightText.isNotEmpty && lightSubtext.isNotEmpty) {
          _lightColorTheme = ColorThemeModel(
            primaryColor: Color(int.parse(lightPrimary)),
            secondaryColor: Color(int.parse(lightSecondary)),
            tertiaryColor: Color(int.parse(lightTertiary)),
            surfaceColor: Color(int.parse(lightSurface)),
            errorColor: Color(int.parse(lightError)),
            textColor: Color(int.parse(lightText)),
            subtextColor: Color(int.parse(lightSubtext)),
          );
        }
      }

      // For now, use light theme colors for dark theme (can be extended later)
      _darkColorTheme = ColorThemeModel(
        primaryColor: _lightColorTheme.primaryColor,
        secondaryColor: _lightColorTheme.secondaryColor,
        tertiaryColor: _lightColorTheme.tertiaryColor,
        surfaceColor: _isDarkMode ? const Color(0xFF1C1B1F) : const Color(0xFFFFFBFE),
        errorColor: _isDarkMode ? const Color(0xFFF2B8B5) : _lightColorTheme.errorColor,
        textColor: _isDarkMode ? const Color(0xFFE6E1E5) : _lightColorTheme.textColor,
        subtextColor: _isDarkMode ? const Color(0xFFCAC4D0) : _lightColorTheme.subtextColor,
      );
    } catch (e) {
      // Handle any errors during loading
      _isDarkMode = false;
      _lightColorTheme = ColorThemeModel.defaultLight;
      _darkColorTheme = ColorThemeModel.defaultDark;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    if (_isDarkMode == value || _isChanging) return;
    
    _isChanging = true;
    notifyListeners();
    
    try {
      _isDarkMode = value;
      
      // Reset to default colors when toggling
      _lightColorTheme = ColorThemeModel.defaultLight;
      _darkColorTheme = ColorThemeModel.defaultDark;
      
      notifyListeners();
      
      await _settingService.setSetting(Setting.darkMode, value.toString());
    } catch (e) {
      _isDarkMode = !value;
      notifyListeners();
    } finally {
      _isChanging = false;
      notifyListeners();
    }
  }

  Future<void> updateColorTheme(ColorThemeModel colorTheme) async {
    try {
      // Update the current theme based on dark mode state
      if (_isDarkMode) {
        _darkColorTheme = colorTheme;
      } else {
        _lightColorTheme = colorTheme;
      }
      
      notifyListeners();

      // Save to database
      await _settingService.setSetting(
        Setting.themePrimaryColor, 
        colorTheme.primaryColor.value.toString(),
      );
      await _settingService.setSetting(
        Setting.themeSecondaryColor, 
        colorTheme.secondaryColor.value.toString(),
      );
      await _settingService.setSetting(
        Setting.themeTertiaryColor, 
        colorTheme.tertiaryColor.value.toString(),
      );
      await _settingService.setSetting(
        Setting.themeSurfaceColor, 
        colorTheme.surfaceColor.value.toString(),
      );
      await _settingService.setSetting(
        Setting.themeErrorColor, 
        colorTheme.errorColor.value.toString(),
      );
      await _settingService.setSetting(
        Setting.themeTextColor, 
        colorTheme.textColor.value.toString(),
      );
      await _settingService.setSetting(
        Setting.themeSubtextColor, 
        colorTheme.subtextColor.value.toString(),
      );
    } catch (e) {
      // Revert on error
      await _loadSettings();
    }
  }

  Future<void> resetToDefaultColors() async {
    try {
      if (_isDarkMode) {
        _darkColorTheme = ColorThemeModel.defaultDark;
      } else {
        _lightColorTheme = ColorThemeModel.defaultLight;
      }
      notifyListeners();

      // Clear from database
      await _settingService.deleteSetting(Setting.themePrimaryColor);
      await _settingService.deleteSetting(Setting.themeSecondaryColor);
      await _settingService.deleteSetting(Setting.themeTertiaryColor);
      await _settingService.deleteSetting(Setting.themeSurfaceColor);
      await _settingService.deleteSetting(Setting.themeErrorColor);
      await _settingService.deleteSetting(Setting.themeTextColor);
      await _settingService.deleteSetting(Setting.themeSubtextColor);
    } catch (e) {
      await _loadSettings();
    }
  }
} 
