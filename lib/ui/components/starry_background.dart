import 'dart:math';
import 'package:flutter/material.dart';

class StarryBackground extends StatefulWidget {
  final Widget child;
  
  const StarryBackground({super.key, required this.child});
  
  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    // Generate random stars
    for (int i = 0; i < 50; i++) {
      _stars.add(Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 0.5,
        opacity: _random.nextDouble() * 0.5 + 0.3,
      ));
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarryPainter(_stars, _controller.value),
          child: widget.child,
        );
      },
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  
  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
  });
}

class StarryPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  
  StarryPainter(this.stars, this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    for (final star in stars) {
      final opacity = star.opacity + (animationValue * 0.2);
      paint.color = Colors.white.withOpacity(opacity.clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(StarryPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}






