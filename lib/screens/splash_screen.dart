import 'package:flutter/material.dart';
import '../theme/snaply_theme.dart';
import '../components/app_icon.dart';
import 'dart:async';
import 'dart:math' as math;

/// Premium animated splash screen for Snaply
class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashScreen({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: SnaplyTheme.durationLong,
    );

    // Set up animations
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    _controller.forward();

    // Set timer to navigate after animation completes
    Timer(const Duration(milliseconds: 2500), () {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  theme.colorScheme.primary.withOpacity(0.05),
                  theme.colorScheme.secondary.withOpacity(0.03),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                // Subtle background shapes
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.07 * _backgroundAnimation.value,
                    child: _BackgroundShapes(animation: _backgroundAnimation),
                  ),
                ),
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated app icon
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: FadeTransition(
                          opacity: _fadeInAnimation,
                          child: AppIcon(
                            size: 120,
                            showGleam: true,
                            animationController: _controller,
                          ),
                        ),
                      ),

                      SizedBox(height: SnaplyTheme.spaceLG),

                      // Animated app title
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(_fadeInAnimation),
                          child: Text(
                            'Snaply',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: SnaplyTheme.spaceXS),

                      // Animated tagline with refined typography
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _fadeInAnimation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          child: Text(
                            'Quick Edits, Stunning Results',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.7),
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: SnaplyTheme.spaceXXL),

                      // Elegant loading indicator with animation
                      Opacity(
                        opacity: _loadingAnimation.value,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              RotationTransition(
                                turns: Tween<double>(begin: 0, end: 1).animate(
                                  CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.linear,
                                  ),
                                ),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Center(
                                child: AnimatedOpacity(
                                  opacity: _controller.value > 0.7 ? 1.0 : 0.0,
                                  duration: SnaplyTheme.durationShort,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Background decorative shapes with motion effect
class _BackgroundShapes extends StatelessWidget {
  final Animation<double> animation;

  const _BackgroundShapes({required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return CustomPaint(
      painter: _ShapesPainter(
        animation: animation,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  _ShapesPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = primaryColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final secondaryPaint = Paint()
      ..color = secondaryColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw animated circles
    final circleCenter1 = Offset(
      size.width * (0.2 + 0.05 * math.sin(animation.value * math.pi)),
      size.height * (0.3 + 0.05 * math.cos(animation.value * math.pi)),
    );
    canvas.drawCircle(circleCenter1, size.width * 0.15, primaryPaint);

    final circleCenter2 = Offset(
      size.width * (0.8 - 0.05 * math.sin(animation.value * math.pi * 0.5)),
      size.height * (0.7 - 0.05 * math.cos(animation.value * math.pi * 0.5)),
    );
    canvas.drawCircle(circleCenter2, size.width * 0.12, secondaryPaint);

    // Draw animated rounded rectangles
    final rect1 = Rect.fromCenter(
      center: Offset(
        size.width * (0.75 + 0.03 * math.cos(animation.value * math.pi * 0.7)),
        size.height * (0.2 + 0.03 * math.sin(animation.value * math.pi * 0.7)),
      ),
      width: size.width * 0.25,
      height: size.width * 0.25,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect1, Radius.circular(size.width * 0.05)),
      primaryPaint,
    );

    final rect2 = Rect.fromCenter(
      center: Offset(
        size.width * (0.25 - 0.03 * math.cos(animation.value * math.pi * 0.9)),
        size.height * (0.75 - 0.03 * math.sin(animation.value * math.pi * 0.9)),
      ),
      width: size.width * 0.2,
      height: size.width * 0.2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect2, Radius.circular(size.width * 0.08)),
      secondaryPaint,
    );
  }

  @override
  bool shouldRepaint(_ShapesPainter oldDelegate) => true;
}
