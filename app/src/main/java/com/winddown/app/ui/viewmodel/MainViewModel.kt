package com.winddown.app.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.winddown.app.data.repository.WindDownRepository
import com.winddown.app.worker.NotificationScheduler
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainViewModel @Inject constructor(
    private val repository: WindDownRepository,
    private val notificationScheduler: NotificationScheduler
) : ViewModel() {
    
    init {
        initializeApp()
    }
    
    private fun initializeApp() {
        viewModelScope.launch {
            // Initialize default items if needed
            repository.initializeDefaultItems()
            
            // Initialize settings if needed
            repository.initializeSettings()
            
            // Check and reset completion status if it's a new day
            repository.checkAndResetCompletion()
            
            // Schedule notification
            val settings = repository.getSettingsOnce()
            notificationScheduler.scheduleBedtimeNotification(
                settings.bedtimeHour,
                settings.bedtimeMinute
            )
        }
    }
}






