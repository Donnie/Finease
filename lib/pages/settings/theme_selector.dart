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
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const ThemeColorPickerSheet(),
        );
      },
    );
  }
}

class ThemeColorPickerSheet extends StatefulWidget {
  const ThemeColorPickerSheet({super.key});

  @override
  State<ThemeColorPickerSheet> createState() => _ThemeColorPickerSheetState();
}

class _ThemeColorPickerSheetState extends State<ThemeColorPickerSheet>
    with SingleTickerProviderStateMixin {
  late ColorThemeModel _tempColorTheme;
  late TabController _tabController;
  
  final List<_ColorOption> _colorOptions = [
    _ColorOption('primary', 'Primary', 'Buttons & key elements', Icons.radio_button_checked),
    _ColorOption('secondary', 'Secondary', 'Supporting accents', Icons.lens),
    _ColorOption('tertiary', 'Tertiary', 'Additional accents', Icons.circle_outlined),
    _ColorOption('surface', 'Surface', 'Cards & backgrounds', Icons.crop_square),
    _ColorOption('error', 'Error', 'Warnings & errors', Icons.error_outline),
    _ColorOption('text', 'Text', 'Main text color', Icons.text_fields),
    _ColorOption('subtext', 'Subtext', 'Secondary text color', Icons.notes),
  ];

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // Use the current theme based on dark mode state
    _tempColorTheme = themeProvider.currentColorTheme;
    _tabController = TabController(length: _colorOptions.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        case 'text':
          _tempColorTheme = _tempColorTheme.copyWith(textColor: color);
          break;
        case 'subtext':
          _tempColorTheme = _tempColorTheme.copyWith(subtextColor: color);
          break;
      }
    });
    
    // Update immediately for real-time preview
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.updateColorTheme(_tempColorTheme);
  }

  Color _getCurrentColor(String type) {
    switch (type) {
      case 'primary':
        return _tempColorTheme.primaryColor;
      case 'secondary':
        return _tempColorTheme.secondaryColor;
      case 'tertiary':
        return _tempColorTheme.tertiaryColor;
      case 'surface':
        return _tempColorTheme.surfaceColor;
      case 'error':
        return _tempColorTheme.errorColor;
      case 'text':
        return _tempColorTheme.textColor;
      case 'subtext':
        return _tempColorTheme.subtextColor;
      default:
        return _tempColorTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with drag handle
          Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Theme Colors",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: "Reset",
                      onPressed: () {
                        final themeProvider = Provider.of<ThemeProvider>(
                          context,
                          listen: false,
                        );
                        themeProvider.resetToDefaultColors();
                        setState(() {
                          _tempColorTheme = themeProvider.isDarkMode 
                              ? ColorThemeModel.defaultDark 
                              : ColorThemeModel.defaultLight;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Reset to default"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _colorOptions.map((option) {
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(option.icon, size: 18),
                    const SizedBox(width: 6),
                    Text(option.label),
                  ],
                ),
              );
            }).toList(),
          ),
          
          // Color palette
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _colorOptions.map((option) {
                return _CompactColorPicker(
                  selectedColor: _getCurrentColor(option.type),
                  onColorSelected: (color) => _updateColor(option.type, color),
                  description: option.description,
                );
              }).toList(),
            ),
          ),
          
          // Done button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Theme colors saved"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text("Done"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorOption {
  final String type;
  final String label;
  final String description;
  final IconData icon;

  _ColorOption(this.type, this.label, this.description, this.icon);
}

class _CompactColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final String description;

  const _CompactColorPicker({
    required this.selectedColor,
    required this.onColorSelected,
    required this.description,
  });

  static final List<List<Color>> _colorRows = [
    // Row 1: Reds & Pinks
    [
      const Color(0xFFB71C1C), const Color(0xFFD32F2F), const Color(0xFFE57373), const Color(0xFFEF5350),
      const Color(0xFF880E4F), const Color(0xFFC2185B), const Color(0xFFF06292), const Color(0xFFEC407A),
    ],
    // Row 2: Purples & Deep Purples
    [
      const Color(0xFF4A148C), const Color(0xFF7B1FA2), const Color(0xFFBA68C8), const Color(0xFFAB47BC),
      const Color(0xFF311B92), const Color(0xFF512DA8), const Color(0xFF9575CD), const Color(0xFF7E57C2),
    ],
    // Row 3: Indigos & Blues
    [
      const Color(0xFF1A237E), const Color(0xFF303F9F), const Color(0xFF7986CB), const Color(0xFF5C6BC0),
      const Color(0xFF0D47A1), const Color(0xFF1976D2), const Color(0xFF64B5F6), const Color(0xFF42A5F5),
    ],
    // Row 4: Light Blues & Cyans
    [
      const Color(0xFF01579B), const Color(0xFF0288D1), const Color(0xFF4FC3F7), const Color(0xFF29B6F6),
      const Color(0xFF006064), const Color(0xFF0097A7), const Color(0xFF4DD0E1), const Color(0xFF26C6DA),
    ],
    // Row 5: Teals & Greens
    [
      const Color(0xFF004D40), const Color(0xFF00796B), const Color(0xFF4DB6AC), const Color(0xFF26A69A),
      const Color(0xFF1B5E20), const Color(0xFF388E3C), const Color(0xFF81C784), const Color(0xFF66BB6A),
    ],
    // Row 6: Light Greens & Limes
    [
      const Color(0xFF33691E), const Color(0xFF689F38), const Color(0xFFAED581), const Color(0xFF9CCC65),
      const Color(0xFF827717), const Color(0xFFAFB42B), const Color(0xFFDCE775), const Color(0xFFD4E157),
    ],
    // Row 7: Yellows & Ambers
    [
      const Color(0xFFF57F17), const Color(0xFFFBC02D), const Color(0xFFFFF176), const Color(0xFFFFEE58),
      const Color(0xFFFF6F00), const Color(0xFFFFA000), const Color(0xFFFFD54F), const Color(0xFFFFCA28),
    ],
    // Row 8: Oranges & Deep Oranges
    [
      const Color(0xFFE65100), const Color(0xFFF57C00), const Color(0xFFFFB74D), const Color(0xFFFFA726),
      const Color(0xFFBF360C), const Color(0xFFE64A19), const Color(0xFFFF8A65), const Color(0xFFFF7043),
    ],
    // Row 9: Browns & Greys
    [
      const Color(0xFF3E2723), const Color(0xFF5D4037), const Color(0xFFA1887F), const Color(0xFF8D6E63),
      const Color(0xFF212121), const Color(0xFF424242), const Color(0xFF9E9E9E), const Color(0xFFBDBDBD),
    ],
    // Row 10: Blue Greys & Neutrals
    [
      const Color(0xFF263238), const Color(0xFF455A64), const Color(0xFF90A4AE), const Color(0xFF78909C),
      const Color(0xFFFFFBFE), const Color(0xFFF5F5F5), const Color(0xFFE0E0E0), const Color(0xFF1C1B1F),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Description
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Compact color grid
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: _colorRows.map((row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    children: row.map((color) {
                      final isSelected = color.value == selectedColor.value;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onColorSelected(color),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: _getContrastColor(color),
                                    size: 18,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getContrastColor(Color color) {
    // Calculate relative luminance
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

