import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_winddown/providers/reflection_provider.dart';
import 'package:flutter_winddown/providers/summary_provider.dart';
import 'package:flutter_winddown/ui/components/starry_background.dart';
import 'package:flutter_winddown/ui/components/wind_down_button.dart';
import 'package:flutter_winddown/ui/components/calm_card.dart';
import 'package:flutter_winddown/ui/navigation/app_router.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});
  
  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  String? _tappedMessage;
  
  void _handleCalmItemTap(String text) {
    setState(() {
      _tappedMessage = 'That\'s one less thing to carry tonight.';
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _tappedMessage = null;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: AppTheme.textPrimary),
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.settings);
          },
        ),
      ),
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
            child: Consumer<ReflectionProvider>(
              builder: (context, provider, child) {
                if (provider.trustMode) {
                  // In trust mode, there are no items to check, so button is always enabled
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Let go',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        WindDownButton(
                          text: 'Close the Day',
                          enabled: true,
                          onPressed: () async {
                            await context.read<SummaryProvider>().markCompleted();
                            if (mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRouter.summary,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Reflection',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_tappedMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _tappedMessage!,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.accentBlue,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.calmItems.length,
                          itemBuilder: (context, index) {
                            return CalmCard(
                              text: provider.calmItems[index],
                              isChecked: provider.isItemChecked(index),
                              onTap: () {
                                provider.toggleItemChecked(index);
                                _handleCalmItemTap(provider.calmItems[index]);
                              },
                            );
                          },
                        ),
                      ),
                        const SizedBox(height: 24),
                      WindDownButton(
                        text: 'Close the Day',
                        enabled: provider.allItemsCompleted,
                        onPressed: provider.allItemsCompleted ? () async {
                          await context.read<SummaryProvider>().markCompleted();
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouter.summary,
                            );
                          }
                        } : null,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}





