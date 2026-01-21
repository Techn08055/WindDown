import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_winddown/providers/settings_provider.dart';
import 'package:flutter_winddown/ui/components/wind_down_button.dart';
import 'package:flutter_winddown/ui/components/calm_card.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bedtime Section
                const Text(
                  'Bedtime Reminder',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You\'ll receive a notification at this time',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        provider.formattedBedtime,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _TimePicker(
                        initialHour: provider.bedtimeHour,
                        initialMinute: provider.bedtimeMinute,
                        onTimeChanged: (hour, minute) {
                          // Only update the time display, don't schedule yet
                          provider.updateBedtime(hour, minute, scheduleNotification: false);
                        },
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await provider.testNotification();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Test sent!')),
                                );
                              }
                            },
                            child: const Text('Now', style: TextStyle(color: AppTheme.accentBlue, fontSize: 11)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await provider.testScheduledNotification();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Scheduled 10s')),
                                );
                              }
                            },
                            child: const Text('10s', style: TextStyle(color: AppTheme.accentBlue, fontSize: 11)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await provider.testIn1Minute();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Scheduled 1 min')),
                                );
                              }
                            },
                            child: const Text('1min', style: TextStyle(color: AppTheme.accentBlue, fontSize: 11)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await provider.testBedtimeIn2Minutes();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Bedtime test scheduled (+2 min)')),
                                );
                              }
                            },
                            child: const Text('Bedtime+2m', style: TextStyle(color: AppTheme.accentBlue, fontSize: 11)),
                          ),
                          TextButton(
                            onPressed: () async {
                              final message = await provider.checkPendingNotifications();
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Notification Status'),
                                    content: Text(message),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          provider.openAlarmSettings();
                                        },
                                        child: const Text('Enable Alarms'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: const Text('Status', style: TextStyle(color: AppTheme.accentBlue, fontSize: 11)),
                          ),
                        ],
                      ),
                      // Tip for enabling alarms
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => provider.openAlarmSettings(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.settings, color: AppTheme.accentBlue, size: 14),
                              SizedBox(width: 6),
                              Text(
                                'Tap Status to check permissions',
                                style: TextStyle(color: AppTheme.accentBlue, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Trust Mode Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trust Mode',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Replace list with "Let go" action',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: provider.trustMode,
                      onChanged: (_) => provider.toggleTrustMode(),
                      activeColor: AppTheme.accentBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Calm Items Section
                if (!provider.trustMode) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Calm List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: AppTheme.accentBlue),
                        onPressed: () {
                          _showAddCalmItemDialog(context, provider);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...provider.calmItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: CalmCard(
                            text: item,
                            isEditable: true,
                            onTextChanged: (newText) {
                              provider.updateCalmItem(index, newText);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            provider.removeCalmItem(index);
                          },
                        ),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 32),
                
                WindDownButton(
                  text: 'Done',
                  onPressed: () async {
                    // Schedule notification only when user taps Done (final selection)
                    await provider.updateBedtime(
                      provider.bedtimeHour,
                      provider.bedtimeMinute,
                      scheduleNotification: true,
                    );
                    if (context.mounted) {
                      final now = DateTime.now();
                      final hour = provider.bedtimeHour;
                      final minute = provider.bedtimeMinute;
                      final scheduledForTomorrow =
                          (hour < now.hour) || (hour == now.hour && minute <= now.minute);
                      final period = hour >= 12 ? 'PM' : 'AM';
                      final displayHour = hour > 12 
                          ? hour - 12 
                          : (hour == 0 ? 12 : hour);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notification scheduled for '
                            '${scheduledForTomorrow ? "tomorrow" : "today"} at '
                            '$displayHour:${minute.toString().padLeft(2, '0')} $period',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  void _showAddCalmItemDialog(BuildContext context, SettingsProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.softBlue,
        title: const Text(
          'Add Calm Item',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Enter calm statement...',
            hintStyle: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.addCalmItem(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _TimePicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final Function(int hour, int minute) onTimeChanged;
  
  const _TimePicker({
    required this.initialHour,
    required this.initialMinute,
    required this.onTimeChanged,
  });
  
  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;
  
  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }
  
  @override
  void didUpdateWidget(_TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialHour != oldWidget.initialHour && widget.initialHour != _selectedHour) {
      _selectedHour = widget.initialHour;
      _hourController.jumpToItem(_selectedHour);
    }
    if (widget.initialMinute != oldWidget.initialMinute && widget.initialMinute != _selectedMinute) {
      _selectedMinute = widget.initialMinute;
      _minuteController.jumpToItem(_selectedMinute);
    }
  }
  
  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour Picker
        SizedBox(
          width: 80,
          height: 200,
          child: ListWheelScrollView.useDelegate(
            controller: _hourController,
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedHour = index;
              });
              widget.onTimeChanged(_selectedHour, _selectedMinute);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final hour = index;
                final isSelected = hour == _selectedHour;
                return Center(
                  child: Text(
                    hour.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSelected ? 28 : 20,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.accentBlue : AppTheme.textSecondary,
                    ),
                  ),
                );
              },
              childCount: 24,
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontSize: 32,
            color: AppTheme.textPrimary,
          ),
        ),
        // Minute Picker
        SizedBox(
          width: 80,
          height: 200,
          child: ListWheelScrollView.useDelegate(
            controller: _minuteController,
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMinute = index;
              });
              widget.onTimeChanged(_selectedHour, _selectedMinute);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final minute = index;
                final isSelected = minute == _selectedMinute;
                return Center(
                  child: Text(
                    minute.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSelected ? 28 : 20,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.accentBlue : AppTheme.textSecondary,
                    ),
                  ),
                );
              },
              childCount: 60,
            ),
          ),
        ),
      ],
    );
  }
}
