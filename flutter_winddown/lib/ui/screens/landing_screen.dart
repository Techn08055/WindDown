import 'package:flutter/material.dart';
import 'package:winddown/ui/components/starry_background.dart';
import 'package:winddown/ui/components/wind_down_button.dart';
import 'package:winddown/ui/navigation/app_router.dart';
import 'package:winddown/ui/theme/app_theme.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _moonController;
  late Animation<double> _moonScale;
  late Animation<double> _moonAlpha;
  
  @override
  void initState() {
    super.initState();
    _moonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _moonScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _moonController, curve: Curves.easeInOut),
    );
    
    _moonAlpha = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _moonController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _moonController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.deepNavy,
                AppTheme.deepNavy.withOpacity(0.8),
                AppTheme.softBlue.withOpacity(0.3),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _moonController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _moonAlpha.value,
                        child: Transform.scale(
                          scale: _moonScale.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.moonGlow,
                                  AppTheme.moonGlow.withOpacity(0.6),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.moonGlow.withOpacity(0.3),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.nights_stay,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'WindDown',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ease into rest, not reassurance.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  WindDownButton(
                    text: 'Begin WindDown',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.reflection);
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




