import 'package:flutter/material.dart';
import '../../../theme/snaply_theme.dart';

/// Empty state widget for image upload in the edit interface
class ImageUploadArea extends StatelessWidget {
  final VoidCallback onTap;

  const ImageUploadArea({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SnaplyTheme.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add_photo_alternate,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                onPressed: onTap,
              ),
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            Text(
              'Upload an image to edit',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SnaplyTheme.spaceSM),
            Text(
              'Tap the icon to upload a photo from your gallery or take a new one with your camera.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SnaplyTheme.spaceLG),
            ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Upload Image'),
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
}
