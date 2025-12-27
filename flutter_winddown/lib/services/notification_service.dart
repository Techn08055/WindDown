import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channel for Android
    await _createNotificationChannel();
  }
  
  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'winddown_bedtime',
      'WindDown Bedtime',
      description: 'Notifications for your bedtime wind down ritual',
      importance: Importance.high,
      playSound: true,
    );
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
  
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigation will be handled by the app
  }
  
  Future<void> scheduleBedtimeNotification(int hour, int minute) async {
    // Cancel existing notifications
    await _notifications.cancelAll();
    
    // Get current date and time
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    // Schedule daily repeating notification
    await _notifications.zonedSchedule(
      0,
      '🌙 Ready to wind down?',
      'Take a moment to ease into rest.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'winddown_bedtime',
          'WindDown Bedtime',
          channelDescription: 'Notifications for your bedtime wind down ritual',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}




