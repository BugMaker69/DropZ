import 'dart:math';

import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const int dotCount = 6; // عدد الدوائر
  static const double dotRadius = 6.0;
  static const double circleRadius = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? kSecondaryColor : kPrimaryColor;

    return Center(
      child: SizedBox(
        width: 60,
        height: 60,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: DotsPainter(
                animationValue: _controller.value,
                color: color,
                dotCount: dotCount,
                dotRadius: dotRadius,
                circleRadius: circleRadius,
              ),
            );
          },
        ),
      ),
    );
  }
}

class DotsPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final int dotCount;
  final double dotRadius;
  final double circleRadius;

  DotsPainter({
    required this.animationValue,
    required this.color,
    required this.dotCount,
    required this.dotRadius,
    required this.circleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * pi / dotCount) * i + animationValue * 2 * pi;
      final x = center.dx + cos(angle) * circleRadius;
      final y = center.dy + sin(angle) * circleRadius;

      // تدريج اللون لكل نقطة لإعطاء شعور بالحركة
      final alpha = (255 * (i + 1) / dotCount).toInt();
      paint.color = color.withAlpha(alpha);

      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DotsPainter oldDelegate) => true;
}
