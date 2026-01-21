import 'package:flutter/material.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

class WindDownButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool enabled;
  
  const WindDownButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onPressed != null;
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: !isEnabled
              ? [AppTheme.textSecondary.withOpacity(0.3), AppTheme.textSecondary.withOpacity(0.2)]
              : isSecondary
                  ? [AppTheme.softBlue, AppTheme.softBlue]
                  : [AppTheme.accentBlue, AppTheme.accentBlue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: AppTheme.accentBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isEnabled ? Colors.white : AppTheme.textSecondary.withOpacity(0.5),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}






