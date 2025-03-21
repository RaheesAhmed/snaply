import 'package:flutter/material.dart';
import '../../theme/snaply_theme.dart';
import '../../services/gallery_service.dart';
import 'dart:io';

/// Home tab displaying app information and features
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<String> _recentImages = [];
  bool _isLoading = true;
  final GalleryService _galleryService = GalleryService();

  @override
  void initState() {
    super.initState();
    _loadRecentImages();
  }

  Future<void> _loadRecentImages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get recent images from gallery service
      final galleryImages = await _galleryService.getAllImages();
      setState(() {
        // Extract just the paths from GalleryImage objects
        _recentImages = galleryImages.map((img) => img.path).take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _loadRecentImages,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreditsBanner(context),
            Padding(
              padding: const EdgeInsets.all(SnaplyTheme.spaceLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecentEditsSection(context),
                  const SizedBox(height: SnaplyTheme.spaceLG),
                  _buildFeatureSection(context),
                  const SizedBox(height: SnaplyTheme.spaceLG),
                  _buildUpgradeSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditsBanner(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: SnaplyTheme.spaceSM,
        horizontal: SnaplyTheme.spaceLG,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color: theme.colorScheme.onPrimary,
            size: 20,
          ),
          const SizedBox(width: SnaplyTheme.spaceSM),
          Text(
            'Free Plan: 2 edits remaining',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              // Navigate to upgrade options
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: SnaplyTheme.spaceSM,
                vertical: 4,
              ),
              backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Upgrade',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEditsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Edits',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to gallery tab
                DefaultTabController.of(context)?.animateTo(2);
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SnaplyTheme.spaceSM),
        SizedBox(
          height: 150,
          child: _isLoading
              ? _buildLoadingIndicator(theme)
              : _recentImages.isEmpty
                  ? _buildEmptyState(theme)
                  : _buildImageList(theme),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: SnaplyTheme.spaceSM),
          Text(
            'Loading images...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 40,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: SnaplyTheme.spaceSM),
          Text(
            'No edited images yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              // Navigate to edit tab
              DefaultTabController.of(context)?.animateTo(1);
            },
            child: Text('Create your first edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList(ThemeData theme) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _recentImages.length,
      itemBuilder: (context, index) {
        return Container(
          width: 120,
          margin: EdgeInsets.only(
            right: index != _recentImages.length - 1 ? SnaplyTheme.spaceSM : 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to detail view or larger preview
                  },
                  child: Image.file(
                    File(_recentImages[index]),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.surface,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 32,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
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
                    'Edit ${index + 1}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: SnaplyTheme.spaceMD),
        _FeatureItem(
          icon: Icons.auto_fix_high,
          title: 'Smart Editing',
          description:
              'Describe what you want to change, and our AI does the rest.',
        ),
        const SizedBox(height: SnaplyTheme.spaceMD),
        _FeatureItem(
          icon: Icons.chat_bubble_outline,
          title: 'Conversational Interface',
          description:
              'Refine your edits through natural back-and-forth conversation.',
        ),
        const SizedBox(height: SnaplyTheme.spaceMD),
        _FeatureItem(
          icon: Icons.storage,
          title: 'Local Storage',
          description: 'Your edited images are saved locally for easy access.',
        ),
      ],
    );
  }

  Widget _buildUpgradeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 24,
              ),
              const SizedBox(width: SnaplyTheme.spaceSM),
              Text(
                'Premium Features',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: SnaplyTheme.spaceMD),
          Row(
            children: [
              _PremiumFeatureItem(
                icon: Icons.update,
                title: 'Unlimited Edits',
                theme: theme,
              ),
              const SizedBox(width: SnaplyTheme.spaceMD),
              _PremiumFeatureItem(
                icon: Icons.block,
                title: 'No Ads',
                theme: theme,
              ),
              const SizedBox(width: SnaplyTheme.spaceMD),
              _PremiumFeatureItem(
                icon: Icons.bolt,
                title: 'Priority Processing',
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: SnaplyTheme.spaceMD),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Show upgrade options
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: SnaplyTheme.spaceSM,
                ),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Upgrade Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final ThemeData theme;

  const _PremiumFeatureItem({
    required this.icon,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(SnaplyTheme.spaceSM),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(SnaplyTheme.spaceSM),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: SnaplyTheme.spaceMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
