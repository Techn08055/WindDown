import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_winddown/providers/app_provider.dart';
import 'package:flutter_winddown/providers/reflection_provider.dart';
import 'package:flutter_winddown/providers/settings_provider.dart';
import 'package:flutter_winddown/providers/summary_provider.dart';
import 'package:flutter_winddown/services/storage_service.dart';
import 'package:flutter_winddown/services/notification_service.dart';
import 'package:flutter_winddown/ui/navigation/app_router.dart';
import 'package:flutter_winddown/ui/theme/app_theme.dart';

void main() async {
  // CRITICAL: Must be first
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services with error handling
  final storageService = StorageService();
  final notificationService = NotificationService();
  
  try {
    await storageService.init();
  } catch (e) {
    print('Storage init error: $e');
  }
  
  try {
    await notificationService.init();
    await notificationService.requestPermissions();
  } catch (e) {
    print('Notification init error: $e');
  }
  
  // Start the app immediately - don't block on anything else
  runApp(MyApp(
    storageService: storageService,
    notificationService: notificationService,
  ));
  
  // Reschedule bedtime notification in background (after app started)
  _rescheduleBedtimeIfNeeded(storageService, notificationService);
}

/// Reschedules bedtime notification after app starts (non-blocking)
void _rescheduleBedtimeIfNeeded(StorageService storage, NotificationService notifications) {
  Future.delayed(const Duration(seconds: 3), () async {
    try {
      final bedtime = storage.getBedtime();
      if (bedtime != null) {
        final pending = await notifications.getPendingNotifications();
        final hasBedtimeScheduled = pending.any((n) => n.id == 0);
        
        if (!hasBedtimeScheduled) {
          print('Rescheduling bedtime notification for ${bedtime.hour}:${bedtime.minute}');
          await notifications.scheduleBedtimeNotification(bedtime.hour, bedtime.minute);
        } else {
          print('Bedtime already scheduled, skipping');
        }
      }
    } catch (e) {
      print('Error rescheduling bedtime: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final NotificationService notificationService;
  
  const MyApp({
    super.key,
    required this.storageService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider(storageService)),
        ChangeNotifierProvider(create: (_) => StorageServiceProvider(storageService)),
        ChangeNotifierProvider(create: (_) => ReflectionProvider(storageService)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(storageService, notificationService)),
        ChangeNotifierProvider(create: (_) => SummaryProvider(storageService)),
      ],
      child: MaterialApp(
        title: 'WindDown',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRouter.landing,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

// Provider wrapper for StorageService to make it accessible via Provider
class StorageServiceProvider extends ChangeNotifier {
  final StorageService service;
  
  StorageServiceProvider(this.service);
}
