import 'package:flutter/material.dart';
import '../theme/snaply_theme.dart';
import '../components/app_icon.dart';

/// Premium onboarding experience for Snaply
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _dotsController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "AI-Powered Editing",
      description:
          "Transform your photos instantly with Google's Gemini 2.0 technology",
      imagePath: "assets/onboarding/ai_edit.png",
      illustration: _AIIllustration(),
    ),
    OnboardingPage(
      title: "Quick Results",
      description:
          "Get stunning photo edits in seconds with simple text prompts",
      imagePath: "assets/onboarding/quick_results.png",
      illustration: _ResultsIllustration(),
    ),
    OnboardingPage(
      title: "Seamless Sharing",
      description:
          "Share your masterpieces directly to social media in one tap",
      imagePath: "assets/onboarding/sharing.png",
      illustration: _SharingIllustration(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _dotsController = TabController(length: _pages.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _dotsController.animateTo(page);
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: SnaplyTheme.durationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(SnaplyTheme.spaceMD),
                child: TextButton(
                  onPressed: widget.onComplete,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),

            // App Logo
            Padding(
              padding: const EdgeInsets.only(top: SnaplyTheme.spaceMD),
              child: AppIcon(size: 70),
            ),

            const SizedBox(height: SnaplyTheme.spaceSM),

            // App Title
            Text(
              'Snaply',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: SnaplyTheme.spaceXS),

            // App Tagline
            Text(
              'Quick Edits, Stunning Results',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),

            // Main content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: SnaplyTheme.spaceSM),
              child: TabPageSelector(
                controller: _dotsController,
                selectedColor: theme.colorScheme.primary,
                color: theme.colorScheme.primary.withOpacity(0.2),
                indicatorSize: 8,
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(SnaplyTheme.spaceLG),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(SnaplyTheme.spaceLG),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            flex: 5,
            child: Hero(
              tag: 'onboarding_${page.title}',
              child: page.illustration,
            ),
          ),

          const SizedBox(height: SnaplyTheme.spaceLG),

          // Title
          Text(
            page.title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: SnaplyTheme.spaceMD),

          // Description
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Data class for onboarding page content
class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final Widget illustration;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.illustration,
  });
}

/// Custom illustrations for onboarding
class _AIIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          Positioned(
            top: 20,
            left: 30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor.withOpacity(0.1),
              ),
            ),
          ),

          // Photo frame with AI transformation effect
          Center(
            child: Container(
              width: 200,
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withOpacity(0.2),
                    secondaryColor.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: SnaplyTheme.subtleShadow,
              ),
              child: Stack(
                children: [
                  // Half-transformed image representation
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey[300],
                            height: double.infinity,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  primaryColor.withOpacity(0.3),
                                  secondaryColor.withOpacity(0.4),
                                ],
                              ),
                            ),
                            height: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Magic wand icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        shape: BoxShape.circle,
                        boxShadow: SnaplyTheme.subtleShadow,
                      ),
                      child: Icon(
                        Icons.auto_fix_high,
                        color: primaryColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Speed lines background
          Positioned.fill(
            child: CustomPaint(
              painter: _SpeedLinesPainter(
                color: primaryColor.withOpacity(0.1),
              ),
            ),
          ),

          // Clock with fast hand
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                shape: BoxShape.circle,
                boxShadow: SnaplyTheme.subtleShadow,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Clock face
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.surfaceVariant,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Clock center
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Clock hand
                  Positioned(
                    top: 10,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.rotationZ(-0.3),
                      child: Container(
                        width: 3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Motion blur for hand
                  Positioned(
                    top: 20,
                    child: ClipOval(
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: SweepGradient(
                            center: Alignment.bottomCenter,
                            startAngle: 0,
                            endAngle: 3.14 / 2,
                            colors: [
                              secondaryColor.withOpacity(0),
                              secondaryColor.withOpacity(0.1),
                              tertiaryColor.withOpacity(0.1),
                              tertiaryColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image thumbnails showing quick transformations
          Positioned(
            bottom: 50,
            left: 30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.image,
                color: primaryColor.withOpacity(0.7),
              ),
            ),
          ),

          Positioned(
            bottom: 70,
            right: 30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.image,
                color: secondaryColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SharingIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Backdrop elements
          Positioned(
            top: 40,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Main image being shared
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: SnaplyTheme.subtleShadow,
                border: Border.all(
                  color: theme.colorScheme.surfaceVariant,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.photo,
                size: 60,
                color: secondaryColor.withOpacity(0.3),
              ),
            ),
          ),

          // Social media icons
          Positioned(
            bottom: 60,
            left: 40,
            child: _SocialIcon(
              color: tertiaryColor,
              icon: Icons.share,
            ),
          ),

          Positioned(
            bottom: 80,
            right: 60,
            child: _SocialIcon(
              color: primaryColor,
              icon: Icons.send,
            ),
          ),

          Positioned(
            bottom: 40,
            left: 120,
            child: _SocialIcon(
              color: secondaryColor,
              icon: Icons.favorite,
            ),
          ),

          // Connection lines
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: _ConnectionLinesPainter(
              centerPoint: const Offset(0.5, 0.45),
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              tertiaryColor: tertiaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _SocialIcon({
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

class _SpeedLinesPainter extends CustomPainter {
  final Color color;

  _SpeedLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final y = size.height / 12 * i;
      final path = Path()
        ..moveTo(0, y)
        ..lineTo(size.width, y);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SpeedLinesPainter oldDelegate) => false;
}

class _ConnectionLinesPainter extends CustomPainter {
  final Offset centerPoint;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  _ConnectionLinesPainter({
    required this.centerPoint,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center =
        Offset(size.width * centerPoint.dx, size.height * centerPoint.dy);

    // Connection to bottom left icon
    final paint1 = Paint()
      ..color = tertiaryColor.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(size.width * 0.2, size.height * 0.8);

    canvas.drawPath(path1, paint1);

    // Connection to bottom right icon
    final paint2 = Paint()
      ..color = primaryColor.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path2 = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(size.width * 0.8, size.height * 0.75);

    canvas.drawPath(path2, paint2);

    // Connection to bottom center icon
    final paint3 = Paint()
      ..color = secondaryColor.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path3 = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(size.width * 0.4, size.height * 0.85);

    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(_ConnectionLinesPainter oldDelegate) => false;
}
