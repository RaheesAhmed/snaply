import 'package:flutter/material.dart';
import 'theme/snaply_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/theme_showcase.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'components/app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _showOnboarding = prefs.getBool('show_onboarding') ?? true;
      });
    } catch (e) {
      // If we can't access shared preferences, show onboarding by default
      setState(() {
        _showOnboarding = true;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_onboarding', false);
    } catch (e) {
      // If we can't save to shared preferences, that's ok
    }
    if (mounted) {
      setState(() {
        _showOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen first
    if (_showSplash) {
      return SplashScreen(
        onAnimationComplete: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    // After splash, show onboarding if needed
    if (_showOnboarding) {
      return OnboardingScreen(
        onComplete: _completeOnboarding,
      );
    }

    // After onboarding completes, show home screen
    return const HomeScreen();
  }
}
