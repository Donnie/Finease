import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finease/core/export.dart';
import 'package:finease/db/background_images.dart';
import 'package:finease/db/background_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundImageSelectorWidget extends StatefulWidget {
  final VoidCallback? onChange;

  const BackgroundImageSelectorWidget({
    super.key,
    this.onChange,
  });

  @override
  State<BackgroundImageSelectorWidget> createState() =>
      _BackgroundImageSelectorWidgetState();
}

class _BackgroundImageSelectorWidgetState
    extends State<BackgroundImageSelectorWidget> {
  String? _selectedImage;
  List<String> _allImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);
    final backgroundProvider = context.read<BackgroundImageProvider>();
    final selected = backgroundProvider.currentBackground;
    final allImages = await backgroundProvider.getAllBackgrounds();
    setState(() {
      _selectedImage = selected;
      _allImages = allImages;
      _isLoading = false;
    });
  }

  Future<void> _showImageSelector() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Background Image',
                    style: context.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addCustomImage,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Custom Image'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        controller: scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: _allImages.length,
                        itemBuilder: (context, index) {
                          final imagePath = _allImages[index];
                          final isSelected = imagePath == _selectedImage;
                          final backgroundProvider = context.read<BackgroundImageProvider>();
                          final isDefault = backgroundProvider.isDefaultImage(imagePath);

                          return GestureDetector(
                            onTap: () => _selectImage(imagePath),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? context.primary
                                      : context.outline,
                                  width: isSelected ? 3 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildImageWidget(imagePath),
                                    if (isSelected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: context.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: context.onPrimary,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      if (!isDefault)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: IconButton(
                                          icon: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: context.error,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          onPressed: () =>
                                              _removeCustomImage(imagePath),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          context.read<BackgroundImageProvider>()
                                              .getImageDisplayName(imagePath),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    final backgroundProvider = context.read<BackgroundImageProvider>();
    
    if (imagePath == BackgroundImageService.noneBackground) {
      return Container(
        color: context.surfaceVariant,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: 48, color: context.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                'No Background',
                style: TextStyle(color: context.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    } else if (backgroundProvider.isDefaultImage(imagePath)) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: context.surfaceVariant,
            child: const Icon(Icons.broken_image, size: 48),
          );
        },
      );
    }
  }

  Future<void> _selectImage(String imagePath) async {
    final backgroundProvider = context.read<BackgroundImageProvider>();
    await backgroundProvider.setBackground(imagePath);
    setState(() => _selectedImage = imagePath);
    if (mounted) {
      Navigator.pop(context);
      // Notify parent if callback is provided
      widget.onChange?.call();
      
      // Show a snackbar confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Background updated'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _addCustomImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null && mounted) {
        final filePath = result.files.single.path!;
        final backgroundProvider = context.read<BackgroundImageProvider>();
        final addedPath = await backgroundProvider.addCustomBackground(filePath);

        if (!mounted) return;

        if (addedPath != null) {
          await _loadImages();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image added successfully')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add image')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _removeCustomImage(String imagePath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image'),
        content: const Text(
            'Are you sure you want to remove this custom background image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final backgroundProvider = context.read<BackgroundImageProvider>();
      final removed = await backgroundProvider.removeCustomBackground(imagePath);
      
      if (!mounted) return;
      
      if (removed) {
        await _loadImages();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image removed successfully')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = context.watch<BackgroundImageProvider>();
    
    return ListTile(
      leading: const Icon(Icons.wallpaper),
      title: const Text('Background Image'),
      subtitle: _isLoading
          ? const Text('Loading...')
          : Text(_selectedImage != null
              ? backgroundProvider.getImageDisplayName(_selectedImage!)
              : 'None'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _showImageSelector,
    );
  }
}

