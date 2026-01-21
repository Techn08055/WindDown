import 'package:flutter/material.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

class CalmCard extends StatefulWidget {
  final String text;
  final bool isEditable;
  final bool isChecked;
  final ValueChanged<String>? onTextChanged;
  final VoidCallback? onTap;
  
  const CalmCard({
    super.key,
    required this.text,
    this.isEditable = false,
    this.isChecked = false,
    this.onTextChanged,
    this.onTap,
  });
  
  @override
  State<CalmCard> createState() => _CalmCardState();
}

class _CalmCardState extends State<CalmCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _textController = TextEditingController();
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _textController.text = widget.text;
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    if (widget.onTap != null) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      widget.onTap!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.softBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: widget.isEditable && _isEditing
              ? TextField(
                  controller: _textController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  onSubmitted: (value) {
                    setState(() {
                      _isEditing = false;
                    });
                    widget.onTextChanged?.call(value);
                  },
                  onEditingComplete: () {
                    setState(() {
                      _isEditing = false;
                    });
                    widget.onTextChanged?.call(_textController.text);
                  },
                )
              : GestureDetector(
                  onTap: widget.isEditable
                      ? () {
                          setState(() {
                            _isEditing = true;
                          });
                        }
                      : null,
                  child: Row(
                    children: [
                      if (!widget.isEditable)
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.isChecked
                                  ? AppTheme.accentBlue
                                  : Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            color: widget.isChecked
                                ? AppTheme.accentBlue.withOpacity(0.2)
                                : Colors.transparent,
                          ),
                          child: widget.isChecked
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppTheme.accentBlue,
                                )
                              : null,
                        ),
                      Expanded(
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.isChecked
                                ? AppTheme.textPrimary.withOpacity(0.6)
                                : AppTheme.textPrimary,
                            height: 1.5,
                            decoration: widget.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}





