import 'package:finease/core/theme/color_theme_model.dart';
import 'package:finease/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.palette,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text("Theme Colors"),
      subtitle: const Text("Customize app colors"),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const ThemeColorPickerDialog(),
        );
      },
    );
  }
}

class ThemeColorPickerDialog extends StatefulWidget {
  const ThemeColorPickerDialog({super.key});

  @override
  State<ThemeColorPickerDialog> createState() => _ThemeColorPickerDialogState();
}

class _ThemeColorPickerDialogState extends State<ThemeColorPickerDialog> {
  late ColorThemeModel _tempColorTheme;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _tempColorTheme = themeProvider.lightColorTheme;
  }

  void _updateColor(String colorType, Color color) {
    setState(() {
      switch (colorType) {
        case 'primary':
          _tempColorTheme = _tempColorTheme.copyWith(primaryColor: color);
          break;
        case 'secondary':
          _tempColorTheme = _tempColorTheme.copyWith(secondaryColor: color);
          break;
        case 'tertiary':
          _tempColorTheme = _tempColorTheme.copyWith(tertiaryColor: color);
          break;
        case 'surface':
          _tempColorTheme = _tempColorTheme.copyWith(surfaceColor: color);
          break;
        case 'error':
          _tempColorTheme = _tempColorTheme.copyWith(errorColor: color);
          break;
      }
    });
    
    // Update immediately for real-time preview
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.updateColorTheme(_tempColorTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Icon(Icons.palette, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Customize Theme Colors",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Color pickers
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ColorPickerRow(
                      label: "Primary Color",
                      description: "Main brand color for buttons and key elements",
                      color: _tempColorTheme.primaryColor,
                      onColorChanged: (color) => _updateColor('primary', color),
                    ),
                    const SizedBox(height: 16),
                    _ColorPickerRow(
                      label: "Secondary Color",
                      description: "Supporting color for accents",
                      color: _tempColorTheme.secondaryColor,
                      onColorChanged: (color) => _updateColor('secondary', color),
                    ),
                    const SizedBox(height: 16),
                    _ColorPickerRow(
                      label: "Tertiary Color",
                      description: "Additional accent color",
                      color: _tempColorTheme.tertiaryColor,
                      onColorChanged: (color) => _updateColor('tertiary', color),
                    ),
                    const SizedBox(height: 16),
                    _ColorPickerRow(
                      label: "Surface Color",
                      description: "Background color for cards and surfaces",
                      color: _tempColorTheme.surfaceColor,
                      onColorChanged: (color) => _updateColor('surface', color),
                    ),
                    const SizedBox(height: 16),
                    _ColorPickerRow(
                      label: "Error Color",
                      description: "Color for error messages and warnings",
                      color: _tempColorTheme.errorColor,
                      onColorChanged: (color) => _updateColor('error', color),
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(height: 1),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset to Default"),
                    onPressed: () {
                      final themeProvider = Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      );
                      themeProvider.resetToDefaultColors();
                      setState(() {
                        _tempColorTheme = ColorThemeModel.defaultLight;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Theme colors reset to default"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Theme colors saved"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerRow extends StatelessWidget {
  final String label;
  final String description;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _ColorPickerRow({
    required this.label,
    required this.description,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        _ColorPaletteGrid(
          selectedColor: color,
          onColorSelected: onColorChanged,
        ),
      ],
    );
  }
}

class _ColorPaletteGrid extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorPaletteGrid({
    required this.selectedColor,
    required this.onColorSelected,
  });

  static final List<Color> _colorPalette = [
    // Reds
    const Color(0xFFB71C1C),
    const Color(0xFFD32F2F),
    const Color(0xFFE57373),
    const Color(0xFFEF5350),
    // Pinks
    const Color(0xFF880E4F),
    const Color(0xFFC2185B),
    const Color(0xFFF06292),
    const Color(0xFFEC407A),
    // Purples
    const Color(0xFF4A148C),
    const Color(0xFF7B1FA2),
    const Color(0xFFBA68C8),
    const Color(0xFFAB47BC),
    // Deep Purples
    const Color(0xFF311B92),
    const Color(0xFF512DA8),
    const Color(0xFF9575CD),
    const Color(0xFF7E57C2),
    // Indigos
    const Color(0xFF1A237E),
    const Color(0xFF303F9F),
    const Color(0xFF7986CB),
    const Color(0xFF5C6BC0),
    // Blues
    const Color(0xFF0D47A1),
    const Color(0xFF1976D2),
    const Color(0xFF64B5F6),
    const Color(0xFF42A5F5),
    // Light Blues
    const Color(0xFF01579B),
    const Color(0xFF0288D1),
    const Color(0xFF4FC3F7),
    const Color(0xFF29B6F6),
    // Cyans
    const Color(0xFF006064),
    const Color(0xFF0097A7),
    const Color(0xFF4DD0E1),
    const Color(0xFF26C6DA),
    // Teals
    const Color(0xFF004D40),
    const Color(0xFF00796B),
    const Color(0xFF4DB6AC),
    const Color(0xFF26A69A),
    // Greens
    const Color(0xFF1B5E20),
    const Color(0xFF388E3C),
    const Color(0xFF81C784),
    const Color(0xFF66BB6A),
    // Light Greens
    const Color(0xFF33691E),
    const Color(0xFF689F38),
    const Color(0xFFAED581),
    const Color(0xFF9CCC65),
    // Limes
    const Color(0xFF827717),
    const Color(0xFFAFB42B),
    const Color(0xFFDCE775),
    const Color(0xFFD4E157),
    // Yellows
    const Color(0xFFF57F17),
    const Color(0xFFFBC02D),
    const Color(0xFFFFF176),
    const Color(0xFFFFEE58),
    // Ambers
    const Color(0xFFFF6F00),
    const Color(0xFFFFA000),
    const Color(0xFFFFD54F),
    const Color(0xFFFFCA28),
    // Oranges
    const Color(0xFFE65100),
    const Color(0xFFF57C00),
    const Color(0xFFFFB74D),
    const Color(0xFFFFA726),
    // Deep Oranges
    const Color(0xFFBF360C),
    const Color(0xFFE64A19),
    const Color(0xFFFF8A65),
    const Color(0xFFFF7043),
    // Browns
    const Color(0xFF3E2723),
    const Color(0xFF5D4037),
    const Color(0xFFA1887F),
    const Color(0xFF8D6E63),
    // Greys
    const Color(0xFF212121),
    const Color(0xFF424242),
    const Color(0xFF9E9E9E),
    const Color(0xFFBDBDBD),
    // Blue Greys
    const Color(0xFF263238),
    const Color(0xFF455A64),
    const Color(0xFF90A4AE),
    const Color(0xFF78909C),
    // Neutrals
    const Color(0xFFFFFBFE),
    const Color(0xFFF5F5F5),
    const Color(0xFFE0E0E0),
    const Color(0xFF1C1B1F),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _colorPalette.map((color) {
        final isSelected = color.value == selectedColor.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

