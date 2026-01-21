import 'package:flutter/material.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

class BreathingAnimation extends StatefulWidget {
  final double size;
  
  const BreathingAnimation({
    super.key,
    this.size = 200,
  });
  
  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isInhaling = true;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.addListener(() {
      final wasInhaling = _isInhaling;
      _isInhaling = _controller.value < 0.5;
      if (wasInhaling != _isInhaling) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3 * _scaleAnimation.value),
                  width: 2,
                ),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.2 * _scaleAnimation.value),
                    Colors.white.withOpacity(0.05 * _scaleAnimation.value),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1 * _scaleAnimation.value),
                    blurRadius: 20 * _scaleAnimation.value,
                    spreadRadius: 5 * _scaleAnimation.value,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _isInhaling ? 'Inhale...' : 'Exhale...',
            key: ValueKey(_isInhaling),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: AppTheme.textPrimary,
              letterSpacing: 3,
            ),
          ),
        ),
      ],
    );
  }
}





