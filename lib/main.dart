import 'package:flutter/material.dart';
import 'theme/snaply_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/theme_showcase.dart';
import 'components/app_icon.dart';

void main() {
  runApp(const SnaplyApp());
}

class SnaplyApp extends StatelessWidget {
  const SnaplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snaply',
      debugShowCheckedModeBanner: false,
      theme: SnaplyTheme.lightTheme,
      home: const AppEntry(),
    );
  }
}

/// Entry point of the app that handles initial navigation flow
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    // Show splash screen first, then navigate to home screen
    if (_showSplash) {
      return SplashScreen(
        onAnimationComplete: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    // After splash animation completes, show home screen
    return const HomeScreen();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo with custom icon
            AppIcon(size: 120),
            SizedBox(height: SnaplyTheme.spaceLG),
            // App title with premium typography
            Text(
              'Snaply',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(height: SnaplyTheme.spaceXS),
            // App tagline with refined typography
            Text(
              'Quick Edits, Stunning Results',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: SnaplyTheme.spaceXL),
            // Button to view theme showcase
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThemeShowcase(),
                  ),
                );
              },
              child: const Text('View Design System'),
            ),
          ],
        ),
      ),
    );
  }
}
