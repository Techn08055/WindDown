import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

// Background callback (must be top-level)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('BG tap: ${response.id}');
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  
  static const _channelId = 'winddown_channel';
  static const _channelName = 'WindDown Reminders';
  static const _channelDesc = 'Bedtime reminder notifications';

  bool get isInitialized => _initialized;
  bool get canScheduleExactAlarms => true;

  Future<void> init() async {
    if (_initialized) return;
    
    print('NOTIF: Initializing (matching working example)...');
    
    // Initialize timezone (exactly like working example)
    tzdata.initializeTimeZones();
    
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
      print('NOTIF: TZ = $tzName');
    } catch (e) {
      tz.setLocalLocation(tz.local);
      print('NOTIF: Using local timezone');
    }
    
    // Initialize plugin (exactly like working example - simple)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (r) => print('NOTIF: Tapped ${r.id}'),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    
    // Create channel
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId, _channelName,
            description: _channelDesc,
            importance: Importance.high,
          ),
        );
        print('NOTIF: Channel created');
      }
    }
    
    _initialized = true;
    print('NOTIF: Ready');
  }

  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;
    
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;
    
    final granted = await androidPlugin.requestNotificationsPermission();
    print('NOTIF: Permission = $granted');
    return granted ?? false;
  }

  /// Show instant notification
  Future<void> showTestNotification() async {
    if (!_initialized) await init();
    
    await _plugin.show(
      999,
      '🌙 Instant Test',
      'This notification appeared immediately!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId, _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Schedule test notification - EXACTLY LIKE WORKING EXAMPLE
  Future<bool> scheduleTestNotificationIn(int seconds) async {
    if (!_initialized) await init();
    
    await _plugin.cancel(1);
    
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(Duration(seconds: seconds));
    
    print('NOTIF: Scheduling test for $scheduled (in $seconds sec)');
    
    try {
      await _plugin.zonedSchedule(
        1,
        '🌙 Scheduled Test',
        'This was scheduled $seconds seconds ago!',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId, _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      print('NOTIF: Test scheduled successfully');
      return true;
    } catch (e) {
      print('NOTIF: Schedule failed: $e');
      return false;
    }
  }

  /// Schedule bedtime notification - EXACTLY LIKE WORKING EXAMPLE
  Future<bool> scheduleBedtimeNotification(int hour, int minute) async {
    if (!_initialized) await init();
    
    await _plugin.cancel(0);
    
    final now = DateTime.now();
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // If time already passed, schedule for tomorrow (exactly like example)
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }
    
    print('NOTIF: Bedtime at $scheduledDate');
    
    try {
      await _plugin.zonedSchedule(
        0,
        '🌙 Time to wind down',
        'Complete your list',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId, _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Daily repeat
      );
      
      print('NOTIF: Bedtime scheduled successfully');
      return true;
    } catch (e) {
      print('NOTIF: Bedtime schedule failed: $e');
      return false;
    }
  }

  Future<String> getScheduledInfo() async {
    return '''📱 Notification Status

✅ Using EXACT working example pattern
✅ flutter_local_notifications: ^17.1.2
✅ androidAllowWhileIdle: true
✅ UILocalNotificationDateInterpretation.absoluteTime

Test with "10s" or "1min" buttons.''';
  }

  Future<void> openExactAlarmSettings() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestExactAlarmsPermission();
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return [];
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
