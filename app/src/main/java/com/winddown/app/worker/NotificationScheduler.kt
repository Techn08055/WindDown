package com.winddown.app.worker

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.work.*
import com.winddown.app.receiver.AlarmReceiver
import dagger.hilt.android.qualifiers.ApplicationContext
import java.util.*
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class NotificationScheduler @Inject constructor(
    @ApplicationContext private val context: Context,
    private val workManager: WorkManager
) {
    
    fun scheduleBedtimeNotification(hour: Int, minute: Int) {
        // Cancel existing work
        workManager.cancelUniqueWork(BedtimeNotificationWorker.WORK_NAME)
        
        // Cancel existing alarm
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
        
        // Use AlarmManager for Android 12+ for exact alarms (more reliable for daily notifications)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            scheduleWithAlarmManager(hour, minute)
        } else {
            scheduleWithWorkManager(hour, minute)
        }
    }
    
    private fun scheduleWithWorkManager(hour: Int, minute: Int) {
        val currentTime = Calendar.getInstance()
        val targetTime = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            
            // If the time has passed today, schedule for tomorrow
            if (before(currentTime)) {
                add(Calendar.DAY_OF_MONTH, 1)
            }
        }
        
        val delay = targetTime.timeInMillis - currentTime.timeInMillis
        
        val workRequest = OneTimeWorkRequestBuilder<BedtimeNotificationWorker>()
            .setInitialDelay(delay, TimeUnit.MILLISECONDS)
            .setConstraints(
                Constraints.Builder()
                    .setRequiresBatteryNotLow(false)
                    .build()
            )
            .build()
        
        workManager.enqueueUniqueWork(
            BedtimeNotificationWorker.WORK_NAME,
            ExistingWorkPolicy.REPLACE,
            workRequest
        )
    }
    
    private fun scheduleWithAlarmManager(hour: Int, minute: Int) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("hour", hour)
            putExtra("minute", minute)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        val currentTime = Calendar.getInstance()
        val targetTime = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            
            // If the time has passed today, schedule for tomorrow
            if (before(currentTime) || equals(currentTime)) {
                add(Calendar.DAY_OF_MONTH, 1)
            }
        }
        
        // Check if we can schedule exact alarms on Android 12+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (alarmManager.canScheduleExactAlarms()) {
                try {
                    // Cancel any existing repeating alarm first
                    alarmManager.cancel(pendingIntent)
                    // Use setExactAndAllowWhileIdle for more reliable scheduling
                    // Note: setRepeating is deprecated, so we schedule daily manually
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        targetTime.timeInMillis,
                        pendingIntent
                    )
                } catch (e: Exception) {
                    // Fallback to inexact alarm
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        targetTime.timeInMillis,
                        pendingIntent
                    )
                }
            } else {
                // Fallback: schedule one-time and reschedule in receiver
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    targetTime.timeInMillis,
                    pendingIntent
                )
            }
        } else {
            // For older Android versions, use setExactAndAllowWhileIdle
            try {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    targetTime.timeInMillis,
                    pendingIntent
                )
            } catch (e: Exception) {
                // Fallback
                alarmManager.set(AlarmManager.RTC_WAKEUP, targetTime.timeInMillis, pendingIntent)
            }
        }
    }
    
    fun cancelNotification() {
        workManager.cancelUniqueWork(BedtimeNotificationWorker.WORK_NAME)
        
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
    
    companion object {
        private const val ALARM_REQUEST_CODE = 1002
    }
}


