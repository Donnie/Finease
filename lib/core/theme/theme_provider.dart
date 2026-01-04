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
        
        if (lightSecondary.isNotEmpty && lightTertiary.isNotEmpty && 
            lightSurface.isNotEmpty && lightError.isNotEmpty) {
          _lightColorTheme = ColorThemeModel(
            primaryColor: Color(int.parse(lightPrimary)),
            secondaryColor: Color(int.parse(lightSecondary)),
            tertiaryColor: Color(int.parse(lightTertiary)),
            surfaceColor: Color(int.parse(lightSurface)),
            errorColor: Color(int.parse(lightError)),
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
      // Update immediately for real-time preview
      _lightColorTheme = colorTheme;
      
      // Update dark theme surface and error colors appropriately
      _darkColorTheme = ColorThemeModel(
        primaryColor: colorTheme.primaryColor,
        secondaryColor: colorTheme.secondaryColor,
        tertiaryColor: colorTheme.tertiaryColor,
        surfaceColor: const Color(0xFF1C1B1F),
        errorColor: const Color(0xFFF2B8B5),
      );
      
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
    } catch (e) {
      // Revert on error
      await _loadSettings();
    }
  }

  Future<void> resetToDefaultColors() async {
    try {
      _lightColorTheme = ColorThemeModel.defaultLight;
      _darkColorTheme = ColorThemeModel.defaultDark;
      notifyListeners();

      // Clear from database
      await _settingService.deleteSetting(Setting.themePrimaryColor);
      await _settingService.deleteSetting(Setting.themeSecondaryColor);
      await _settingService.deleteSetting(Setting.themeTertiaryColor);
      await _settingService.deleteSetting(Setting.themeSurfaceColor);
      await _settingService.deleteSetting(Setting.themeErrorColor);
    } catch (e) {
      await _loadSettings();
    }
  }
} 
