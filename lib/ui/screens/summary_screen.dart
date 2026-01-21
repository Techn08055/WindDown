import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_winddown/providers/summary_provider.dart';
import 'package:flutter_winddown/ui/components/starry_background.dart';
import 'package:flutter_winddown/ui/components/breathing_animation.dart';
import 'package:flutter_winddown/ui/navigation/app_router.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});
  
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
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Consumer<SummaryProvider>(
                builder: (context, provider, child) {
                  final completedToday = provider.completedToday;
                  final completionTime = provider.formattedCompletionTime;
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (completedToday && completionTime.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              'You wrapped up at $completionTime.',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.textPrimary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You\'re safe to rest.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                          ],
                        )
                      else
                        Column(
                          children: [
                            const Text(
                              'You already wrapped up tonight.',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.textPrimary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try a deep breath?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                      const BreathingAnimation(size: 200),
                      const SizedBox(height: 64),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRouter.reflection,
                            (route) => route.settings.name == AppRouter.landing || route.isFirst,
                          );
                        },
                        child: const Text(
                          'Edit List',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}





