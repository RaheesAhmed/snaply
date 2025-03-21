import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/app_icon.dart';
import '../theme/snaply_theme.dart';
import 'home_tab/home_tab.dart';
import 'edit_tab/edit_tab.dart';
import 'gallery_tab/gallery_tab.dart';

/// Main screen for Snaply with tabbed navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const EditTab(),
    const GalleryTab(),
  ];

  final List<String> _tabTitles = [
    'Home',
    'Edit',
    'Gallery',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(size: 28),
            const SizedBox(width: SnaplyTheme.spaceXS),
            Text(
              'Snaply',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help/tips dialog
              _showTipsDialog();
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: _tabTitles[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.edit_outlined),
            selectedIcon: const Icon(Icons.edit),
            label: _tabTitles[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.photo_library_outlined),
            selectedIcon: const Icon(Icons.photo_library),
            label: _tabTitles[2],
          ),
        ],
      ),
    );
  }

  void _showTipsDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tips & Features',
          style: theme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TipItem(
              icon: Icons.home,
              title: 'Home',
              description: 'Discover features and get started with Snaply.',
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            _TipItem(
              icon: Icons.edit,
              title: 'Edit Images',
              description: 'Upload photos and describe your desired edits.',
            ),
            const SizedBox(height: SnaplyTheme.spaceMD),
            _TipItem(
              icon: Icons.photo_library,
              title: 'Gallery',
              description: 'View, share, and manage your edited images.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipItem({
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
          padding: const EdgeInsets.all(SnaplyTheme.spaceXS),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: SnaplyTheme.spaceSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
