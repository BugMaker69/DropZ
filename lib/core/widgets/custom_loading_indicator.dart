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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: _animation,
              child: CustomPaint(
                painter: DotsPainter(
                  color: isDarkMode ? kSecondaryColor : kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotsPainter extends CustomPainter {
  final Color color;

  DotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const dotRadius = 6.0;
    const spacing = 12.0;

    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * (3.14159 / 180);
      final x = size.width / 2 + cos(angle) * (size.width / 4);
      final y = size.height / 2 + sin(angle) * (size.height / 4);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
