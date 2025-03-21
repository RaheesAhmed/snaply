import 'package:flutter/material.dart';
import '../theme/snaply_theme.dart';
import 'dart:math' as math;

/// A custom widget for rendering the Snaply app icon
/// This provides a consistent icon appearance throughout the app
class AppIcon extends StatelessWidget {
  /// Size of the icon
  final double size;

  /// Whether to show a gleam effect
  final bool showGleam;

  /// Animation controller for the gleam effect
  final Animation<double>? animationController;

  const AppIcon({
    super.key,
    this.size = 120,
    this.showGleam = false,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.15),
            secondaryColor.withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gleam effect if enabled
          if (showGleam && animationController != null)
            AnimatedBuilder(
              animation: animationController!,
              builder: (context, child) {
                return Positioned(
                  left: -size / 3 + (size * 5 / 3 * animationController!.value),
                  top: 0,
                  child: Transform(
                    transform: Matrix4.rotationZ(0.8),
                    child: Container(
                      width: size / 2,
                      height: size,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // App icon - magic wand
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Wand stick
                Transform.rotate(
                  angle: -0.6,
                  child: Container(
                    width: size * 0.08,
                    height: size * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size * 0.04),
                    ),
                  ),
                ),

                // Wand star tip
                Positioned(
                  top: size * 0.24,
                  left: size * 0.6,
                  child: CustomPaint(
                    size: Size(size * 0.2, size * 0.2),
                    painter: _StarPainter(color: Colors.white),
                  ),
                ),

                // Sparkles
                Positioned(
                  top: size * 0.2,
                  right: size * 0.22,
                  child: Container(
                    width: size * 0.06,
                    height: size * 0.06,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: size * 0.32,
                  right: size * 0.35,
                  child: Container(
                    width: size * 0.04,
                    height: size * 0.04,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing a star shape
class _StarPainter extends CustomPainter {
  final Color color;

  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final outerRadius = size.width / 2;
    final innerRadius = size.width / 5;
    const numPoints = 4;

    for (int i = 0; i < numPoints * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = i * 3.14159 / numPoints;

      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
