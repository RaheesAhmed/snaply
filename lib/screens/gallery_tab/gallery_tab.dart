import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/gallery_service.dart';
import '../../services/event_bus.dart';
import '../../theme/snaply_theme.dart';

/// Gallery tab displaying user's edited images
class GalleryTab extends StatefulWidget {
  const GalleryTab({super.key});

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  final GalleryService _galleryService = GalleryService();
  List<GalleryImage> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final images = await _galleryService.getAllImages();
      setState(() {
        _images = images;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading gallery images: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteImage(String imageId) async {
    try {
      final success = await _galleryService.deleteImage(imageId);
      if (success) {
        setState(() {
          _images.removeWhere((img) => img.id == imageId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image deleted successfully')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_images.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: _loadGalleryImages,
      child: Padding(
        padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Gallery',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: SnaplyTheme.spaceSM,
                  mainAxisSpacing: SnaplyTheme.spaceSM,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final image = _images[index];
                  return GalleryItem(
                    imagePath: image.path,
                    onTap: () => _showImageDetails(context, image),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SnaplyTheme.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            Text(
              'Your Gallery is Empty',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SnaplyTheme.spaceSM),
            Text(
              'Edit some images and they will appear here automatically.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SnaplyTheme.spaceLG),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to edit tab
                DefaultTabController.of(context)?.animateTo(1);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Start Editing'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: SnaplyTheme.spaceLG,
                  vertical: SnaplyTheme.spaceSM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDetails(BuildContext context, GalleryImage image) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SnaplyTheme.spaceSM,
                ),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onBackground.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: SnaplyTheme.spaceMD),
                    if (image.description.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: SnaplyTheme.spaceMD),
                        child: Text(
                          image.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    Text(
                      'Created: ${_formatDate(image.timestamp)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: SnaplyTheme.spaceMD),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () {
                            Share.shareXFiles([XFile(image.path)]);
                            Navigator.pop(context);
                          },
                        ),
                        _ActionButton(
                          icon: Icons.edit,
                          label: 'Edit Again',
                          onTap: () {
                            // Navigate to edit tab and pass the image
                            Navigator.pop(context);
                            // Use EventBus to send the image to the edit tab
                            EventBus().sendImageToEdit(File(image.path));
                            // Navigate to edit tab
                            DefaultTabController.of(context)?.animateTo(1);
                          },
                        ),
                        _ActionButton(
                          icon: Icons.delete_outline,
                          label: 'Delete',
                          onTap: () {
                            Navigator.pop(context);
                            _deleteImage(image.id);
                          },
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class GalleryItem extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const GalleryItem({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(SnaplyTheme.spaceSM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
