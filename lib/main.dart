import 'package:flutter/material.dart';
import 'theme/snaply_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/theme_showcase.dart';

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
            // App logo container with gradient background
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    Theme.of(context).colorScheme.primary.withOpacity(0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.auto_fix_high,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
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
